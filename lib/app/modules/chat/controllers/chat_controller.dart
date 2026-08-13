import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_royal/app/domain/entities/product_by_id_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/log/logger.dart';
import '../../../data/models/chat_message_model.dart';
import '../../../domain/entities/chat_message_entity.dart';
import '../../../domain/entities/conversation_entity.dart';
import '../../../domain/usecases/chat/get_conversations_usecase.dart';
import '../../../domain/usecases/chat/get_messages_usecase.dart';
import '../../../domain/usecases/chat/manage_pusher_usecase.dart';
import '../../../domain/usecases/chat/send_message_usecase.dart';
import '../../../domain/usecases/chat/subscribe_to_messages_stream_usecase.dart';

class ChatController extends GetxController {
  final GetConversationsUseCase _getConversationsUseCase;
  final GetMessagesUseCase _getMessagesUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final ManagePusherUseCase _managePusherUseCase;
  final SubscribeToMessagesStreamUseCase _subscribeToMessagesStreamUseCase;

  ChatController({
    GetConversationsUseCase? getConversationsUseCase,
    GetMessagesUseCase? getMessagesUseCase,
    SendMessageUseCase? sendMessageUseCase,
    ManagePusherUseCase? managePusherUseCase,
    SubscribeToMessagesStreamUseCase? subscribeToMessagesStreamUseCase,
  })  : _getConversationsUseCase = getConversationsUseCase ?? Get.find(),
        _getMessagesUseCase = getMessagesUseCase ?? Get.find(),
        _sendMessageUseCase = sendMessageUseCase ?? Get.find(),
        _managePusherUseCase = managePusherUseCase ?? Get.find(),
        _subscribeToMessagesStreamUseCase =
            subscribeToMessagesStreamUseCase ?? Get.find();

  final conversations = <ConversationEntity>[].obs;
  final selectedConversation = Rxn<ConversationEntity>();
  final messages = <ChatMessageEntity>[].obs;
  final isLoading = false.obs;
  final draft = ''.obs;
  final textController = TextEditingController();
  final scrollController = ScrollController();
  final error = ''.obs;
  final pusherState = 'DISCONNECTED'.obs;
  Rx<ProductByIdEntity> productByID = ProductByIdEntity().obs;
  RxInt selectedIndex = 0.obs;

  String conversationId = '';
  final List<ChatMessageEntity> pending = [];
  StreamSubscription? _pusherEventSubscription;
  StreamSubscription? _pusherConnectionSubscription;

  String get pendingKey => 'chat_pending_$conversationId';

  List<String> get pusherChannelNames => [
        'conversation.$conversationId',
        'private-conversation.$conversationId',
        'chat.$conversationId',
        'private-chat.$conversationId',
      ];

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    productByID = Get.arguments[0];
    selectedIndex.value = Get.arguments[1];
    if (args is String && args.isNotEmpty) {
      conversationId = args;
    } else if (args is Map && args['conversationId'] is String) {
      conversationId = args['conversationId'] as String;
    } else if (args is Map && args['chatId'] is String) {
      conversationId = args['chatId'] as String;
    } else {
      conversationId = '';
    }

    // Scroll to bottom when messages update
    ever(messages, (_) {
      WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
    });

    _initDataAndPusher();
  }

  Future<void> _initDataAndPusher() async {
    isLoading.value = true;
    try {
      // 1. Fetch conversations list
      try {
        final convs = await _getConversationsUseCase();
        conversations.assignAll(convs);
        if (convs.isNotEmpty) {
          final matched = convs.firstWhere(
            (c) => conversationId.isNotEmpty && c.id == conversationId,
            orElse: () => convs[0],
          );
          selectedConversation.value = matched;
          conversationId = matched.id;
        }
      } catch (e) {
        logger.warning('Could not load conversations: $e');
      }

      // 2. Fetch messages for active conversation via REST API
      await fetchMessages();

      // 3. Setup Pusher WebSockets real-time stream subscription & network reconnect listener
      await _setupPusher();

      // 4. Flush local pending messages
      await loadPendingAndFlush();
    } catch (e) {
      error.value = 'Gagal memuat data obrolan: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMessages() async {
    if (conversationId.isEmpty || conversationId == 'default_conversation') {
      return;
    }
    try {
      final fetched = await _getMessagesUseCase(conversationId);
      // Sort ascending by creation time so newest are at the bottom
      fetched.sort((a, b) {
        final tA = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final tB = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return tA.compareTo(tB);
      });
      messages.assignAll(fetched);
    } catch (e) {
      logger.severe('Failed to fetch messages: $e');
    }
  }

  Future<void> _setupPusher() async {
    try {
      await _managePusherUseCase.initPusher();
      await _managePusherUseCase.connect();

      // Listen to Pusher connection state transitions to auto-flush pending messages when internet returns
      _pusherConnectionSubscription?.cancel();
      _pusherConnectionSubscription =
          _managePusherUseCase.getConnectionStateStream().listen((state) {
        pusherState.value = state;
        logger.info('Pusher connection state changed to: $state');
        if (state == 'CONNECTED') {
          // Internet / WebSocket restored -> flush offline queue automatically
          flushPending();
        }
      });

      if (conversationId.isNotEmpty) {
        // Subscribe to both public & private channel naming variants
        for (final ch in pusherChannelNames) {
          try {
            await _managePusherUseCase.subscribeChannel(ch);
          } catch (e) {
            logger.warning('Subscription skipped for $ch: $e');
          }
        }

        // Listen to live message stream from SubscribeToMessagesStreamUseCase
        _pusherEventSubscription?.cancel();
        _pusherEventSubscription =
            _subscribeToMessagesStreamUseCase(conversationId).listen(
          (incomingMsg) {
            logger.info(
                'Live message received via Pusher Stream: ${incomingMsg.text}');
            final exists = messages.any(
              (m) => m.id.isNotEmpty && m.id == incomingMsg.id,
            );
            if (!exists) {
              messages.add(incomingMsg);
            }
          },
        );
      }
    } catch (e) {
      logger.severe('Failed setting up Pusher stream: $e');
    }
  }

  void onDraftChanged(String value) {
    draft.value = value;
  }

  Future<void> sendMessage() async {
    logger.info('SEND MESSAGE via REST API');
    final trimmed = draft.value.trim();
    if (trimmed.isEmpty) return;

    final tempMessage = ChatMessageEntity(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      senderId: 'current_user',
      senderType: 'user',
      text: trimmed,
      createdAt: DateTime.now(),
    );

    // Optimistic update: show message immediately on UI
    messages.add(tempMessage);
    draft.value = '';
    textController.clear();

    try {
      final sentMessage = await _sendMessageUseCase(conversationId, trimmed);

      // Replace temporary message with actual response from server
      final index = messages.indexWhere((m) => m.id == tempMessage.id);
      if (index != -1) {
        messages[index] = sentMessage;
      } else {
        messages.add(sentMessage);
      }
      error.value = '';
      await flushPending();
    } catch (e) {
      // Save to local offline queue and display notification
      if (!pending.any((m) => m.id == tempMessage.id)) {
        pending.add(tempMessage);
        await savePending();
      }
      error.value =
          'Koneksi terputus. Pesan disimpan offline & akan otomatis dikirim saat terhubung kembali.';
      logger.warning('Failed to send message via API, queued locally: $e');
    }
  }

  Future<void> savePending() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = pending
          .map((m) => jsonEncode({
                'id': m.id,
                'conversation_id': m.conversationId,
                'sender_id': m.senderId,
                'sender_type': m.senderType,
                'text': m.text,
                'is_read': m.isRead,
                'created_at': m.createdAt?.toIso8601String(),
              }))
          .toList();
      await prefs.setStringList(pendingKey, list);
    } catch (e) {
      logger.warning('Failed to save pending messages: $e');
    }
  }

  Future<void> loadPendingAndFlush() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getStringList(pendingKey) ?? [];
      pending.clear();
      for (final s in stored) {
        try {
          final map = jsonDecode(s) as Map<String, dynamic>;
          pending.add(ChatMessageModel.fromJson(map).toEntity());
        } catch (_) {}
      }
      if (pending.isNotEmpty) {
        error.value = 'Ada pesan offline yang menunggu dikirim...';
        await flushPending();
      }
    } catch (e) {
      logger.warning('Failed to load pending messages: $e');
    }
  }

  Future<void> flushPending() async {
    if (pending.isEmpty) {
      error.value = '';
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(pendingKey);
      return;
    }

    final toSend = List<ChatMessageEntity>.from(pending);
    for (final msg in toSend) {
      try {
        final sent = await _sendMessageUseCase(msg.conversationId, msg.text);

        // Update temporary bubble to confirmed server message
        final tempIndex =
            messages.indexWhere((m) => m.id == msg.id || m.text == msg.text);
        if (tempIndex != -1) {
          messages[tempIndex] = sent;
        } else {
          messages.add(sent);
        }

        pending.remove(msg);
        await savePending();
      } catch (e) {
        logger.warning('Retry failed for pending message: $e');
        error.value =
            'Belum terhubung ke internet. Menunggu koneksi kembali...';
        return;
      }
    }

    error.value = '';
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(pendingKey);
  }

  void scrollToBottom() {
    try {
      if (!scrollController.hasClients) return;
      final target = scrollController.position.maxScrollExtent;
      scrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } catch (_) {}
  }

  Future<void> retryPending() async {
    await flushPending();
  }

  @override
  void onClose() {
    _pusherEventSubscription?.cancel();
    _pusherConnectionSubscription?.cancel();
    if (conversationId.isNotEmpty) {
      for (final ch in pusherChannelNames) {
        _managePusherUseCase.unsubscribeChannel(ch);
      }
    }
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
