import '../entities/chat_message_entity.dart';
import '../entities/conversation_entity.dart';

abstract class ChatRepository {
  /// Fetch all conversations from backend REST API
  Future<List<ConversationEntity>> getConversations();

  /// Fetch all messages for a specific conversation ID from backend REST API
  Future<List<ChatMessageEntity>> getMessages(String conversationId);

  /// Send a text message to a specific conversation ID via backend REST API
  Future<ChatMessageEntity> sendMessage(String conversationId, String text);

  /// Initialize Pusher WebSocket connection with API key & cluster
  Future<void> initPusher({
    String? apiKey,
    String? cluster,
    String? authEndpoint,
  });

  /// Connect to Pusher WebSocket server
  Future<void> connectPusher();

  /// Disconnect from Pusher WebSocket server
  Future<void> disconnectPusher();

  /// Subscribe to a public or private channel
  Future<void> subscribeChannel(
    String channelName, {
    Function(dynamic event)? onEvent,
  });

  /// Unsubscribe from a channel
  Future<void> unsubscribeChannel(String channelName);

  /// Stream of raw real-time Pusher events
  Stream<dynamic> getPusherEventStream();

  /// Stream of Pusher connection state ('CONNECTED', 'DISCONNECTED', 'CONNECTING', etc.)
  Stream<String> getPusherConnectionStateStream();

  /// Reactive Stream of parsed ChatMessageEntity for a specific conversation
  Stream<ChatMessageEntity> subscribeToMessagesStream(String conversationId);
}
