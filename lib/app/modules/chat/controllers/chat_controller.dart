import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/chat_message.dart';

class ChatController extends GetxController {
  final messages = <ChatMessage>[].obs;
  final draft = ''.obs;
  final textController = TextEditingController();
  final scrollController = ScrollController();
  final error = ''.obs;

  late final FirebaseFirestore firestore;
  late final CollectionReference<Map<String, dynamic>> messagesRef;
  late final String chatId;

  final List<ChatMessage> pending = [];

  String get pendingKey => 'chat_pending_$chatId';

  @override
  void onInit() {
    super.onInit();
    firestore = FirebaseFirestore.instance;

    final args = Get.arguments;
    if (args is String) {
      chatId = args;
    } else if (args is Map && args['chatId'] is String) {
      chatId = args['chatId'] as String;
    } else {
      chatId = 'global_chat';
    }

    messagesRef =
        firestore.collection('chats').doc(chatId).collection('messages');

    // Bind Firestore stream to messages list (newest first)
    messages.bindStream(
      messagesRef.orderBy('timestamp', descending: true).snapshots().map(
            (snap) => snap.docs
                .map((d) => ChatMessage.fromMap(d.data(), id: d.id))
                .toList(),
          ),
    );

    // Scroll to bottom when messages update
    ever(messages, (_) {
      WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
    });

    // Load pending messages from local storage and attempt to flush
    loadPendingAndFlush();
  }

  void onDraftChanged(String value) {
    draft.value = value;
  }

  Future<void> sendMessage() async {
    final trimmed = draft.value.trim();
    if (trimmed.isEmpty) return;

    final message = ChatMessage(text: trimmed, sender: ChatSender.user);

    try {
      await messagesRef.add(message.toMap());
      draft.value = '';
      textController.clear();
      error.value = '';

      // Try to send any pending messages after a successful send
      await flushPending();
    } catch (e) {
      // Save to pending queue and show error UI
      pending.add(message);
      await savePending();
      error.value =
          'Pesan disimpan offline, akan dikirim ulang saat jaringan tersedia.';
      debugPrint('Failed to send message, queued locally: $e');
    }
  }

  Future<void> savePending() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = pending.map((m) => jsonEncode(m.toMap())).toList();
      await prefs.setStringList(pendingKey, list);
    } catch (e) {
      debugPrint('Failed to save pending messages: $e');
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
          pending.add(ChatMessage.fromMap(map));
        } catch (_) {}
      }
      if (pending.isNotEmpty) {
        error.value = 'Ada pesan yang menunggu, mencoba mengirim...';
        await flushPending();
      }
    } catch (e) {
      debugPrint('Failed to load pending messages: $e');
    }
  }

  Future<void> flushPending() async {
    if (pending.isEmpty) {
      error.value = '';
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(pendingKey);
      return;
    }

    // copy to avoid mutation during iteration
    final toSend = List<ChatMessage>.from(pending);
    for (final msg in toSend) {
      try {
        await messagesRef.add(msg.toMap());
        pending.remove(msg);
        await savePending();
      } catch (e) {
        debugPrint('Retry failed for pending message: $e');
        // stop further attempts for now
        error.value = 'Gagal mengirim pesan tunggu. Akan dicoba lagi.';
        return;
      }
    }

    // All sent
    error.value = '';
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(pendingKey);
  }

  void scrollToBottom() {
    try {
      if (!scrollController.hasClients) return;
      // For reversed ListView, minScrollExtent corresponds to bottom
      final target = scrollController.position.minScrollExtent;
      scrollController.animateTo(target,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    } catch (e) {
      // ignore
    }
  }

  Future<void> retryPending() async {
    await flushPending();
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
