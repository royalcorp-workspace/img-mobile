import 'dart:convert';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/conversation_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';
import '../datasources/pusher_remote_datasource.dart';
import '../models/chat_message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final PusherRemoteDataSource pusherRemoteDataSource;

  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.pusherRemoteDataSource,
  });

  @override
  Future<List<ConversationEntity>> getConversations() async {
    final models = await remoteDataSource.getConversations();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<ChatMessageEntity>> getMessages(String conversationId) async {
    final models = await remoteDataSource.getMessages(conversationId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<ChatMessageEntity> sendMessage(String conversationId, String text) async {
    final model = await remoteDataSource.sendMessage(conversationId, text);
    return model.toEntity();
  }

  @override
  Future<void> initPusher({
    String? apiKey,
    String? cluster,
    String? authEndpoint,
  }) {
    return pusherRemoteDataSource.init(
      apiKey: apiKey,
      cluster: cluster,
      authEndpoint: authEndpoint,
    );
  }

  @override
  Future<void> connectPusher() {
    return pusherRemoteDataSource.connect();
  }

  @override
  Future<void> disconnectPusher() {
    return pusherRemoteDataSource.disconnect();
  }

  @override
  Future<void> subscribeChannel(
    String channelName, {
    Function(dynamic event)? onEvent,
  }) {
    return pusherRemoteDataSource.subscribe(
      channelName,
      onEvent: onEvent != null ? (e) => onEvent(e) : null,
    );
  }

  @override
  Future<void> unsubscribeChannel(String channelName) {
    return pusherRemoteDataSource.unsubscribe(channelName);
  }

  @override
  Stream<dynamic> getPusherEventStream() {
    return pusherRemoteDataSource.eventStream;
  }

  @override
  Stream<String> getPusherConnectionStateStream() {
    return pusherRemoteDataSource.connectionStateStream;
  }

  @override
  Stream<ChatMessageEntity> subscribeToMessagesStream(String conversationId) async* {
    await for (final event in pusherRemoteDataSource.eventStream) {
      try {
        if (event.eventName.startsWith('pusher:') ||
            event.eventName.startsWith('pusher_internal:')) {
          continue;
        }

        final ch = event.channelName.toLowerCase();
        final convIdLower = conversationId.toLowerCase();
        if (ch.isNotEmpty && !ch.contains(convIdLower)) {
          continue;
        }

        if (event.data == null || event.data.toString().isEmpty) continue;

        Map<String, dynamic> dataMap;
        if (event.data is String) {
          dataMap = jsonDecode(event.data as String) as Map<String, dynamic>;
        } else if (event.data is Map) {
          dataMap = Map<String, dynamic>.from(event.data as Map);
        } else {
          continue;
        }

        final msgJson =
            dataMap.containsKey('message') && dataMap['message'] is Map
                ? dataMap['message'] as Map<String, dynamic>
                : dataMap;

        final incomingMsg = ChatMessageModel.fromJson(msgJson).toEntity();
        if (incomingMsg.text.isNotEmpty || incomingMsg.id.isNotEmpty) {
          yield incomingMsg;
        }
      } catch (_) {}
    }
  }
}
