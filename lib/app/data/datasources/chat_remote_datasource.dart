import 'package:dio/dio.dart';
import '../../core/network/dio_network.dart';
import '../../core/utils/log/logger.dart';
import '../models/chat_message_model.dart';
import '../models/conversation_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ConversationModel>> getConversations();
  Future<List<ChatMessageModel>> getMessages(String conversationId);
  Future<ChatMessageModel> sendMessage(String conversationId, String text);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio _dio;

  ChatRemoteDataSourceImpl({Dio? dio}) : _dio = dio ?? DioNetwork.appAPI;

  @override
  Future<List<ConversationModel>> getConversations() async {
    try {
      final response = await _dio.get('/chat/conversations');
      if (response.statusCode == 200 && response.data != null) {
        final List list = response.data is List ? response.data : [];
        return list
            .map((item) => ConversationModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e, stack) {
      logger.severe('Error fetching conversations: $e', e, stack);
      rethrow;
    }
  }

  @override
  Future<List<ChatMessageModel>> getMessages(String conversationId) async {
    try {
      final response = await _dio.get('/chat/$conversationId/messages');
      if (response.statusCode == 200 && response.data != null) {
        final List<ChatMessageModel> result = [];

        void extractMessagesFromMap(Map<String, dynamic> map) {
          // If the item contains a nested 'messages' array (conversation wrapper response)
          if (map.containsKey('messages') && map['messages'] is List) {
            final List msgs = map['messages'] as List;
            for (final m in msgs) {
              if (m is Map) {
                result.add(ChatMessageModel.fromJson(Map<String, dynamic>.from(m)));
              }
            }
          }
          // If the item itself is a direct message object (contains 'text' or 'sender_id')
          else if (map.containsKey('text') || map.containsKey('sender_id') || map.containsKey('conversation_id')) {
            final msg = ChatMessageModel.fromJson(map);
            if (msg.text.isNotEmpty || msg.id.isNotEmpty) {
              result.add(msg);
            }
          }
        }

        if (response.data is List) {
          for (final item in (response.data as List)) {
            if (item is Map) {
              extractMessagesFromMap(Map<String, dynamic>.from(item));
            }
          }
        } else if (response.data is Map) {
          extractMessagesFromMap(Map<String, dynamic>.from(response.data as Map));
        }

        return result;
      }
      return [];
    } catch (e, stack) {
      logger.severe('Error fetching messages for conversation $conversationId: $e', e, stack);
      rethrow;
    }
  }

  @override
  Future<ChatMessageModel> sendMessage(String conversationId, String text) async {
    try {
      final response = await _dio.post(
        '/chat/$conversationId/messages',
        data: {'text': text},
      );
      if (response.data != null && response.data is Map) {
        final map = Map<String, dynamic>.from(response.data as Map);
        // If response is wrapped inside a 'data' or 'message' key
        if (map.containsKey('message') && map['message'] is Map) {
          return ChatMessageModel.fromJson(Map<String, dynamic>.from(map['message'] as Map));
        }
        return ChatMessageModel.fromJson(map);
      }
      throw Exception('Invalid response format from send message endpoint');
    } catch (e, stack) {
      logger.severe('Error sending message to conversation $conversationId: $e', e, stack);
      rethrow;
    }
  }
}
