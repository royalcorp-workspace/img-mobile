import 'chat_message_entity.dart';

class ConversationEntity {
  final String id;
  final String customerId;
  final String subject;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<ChatMessageEntity> messages;

  const ConversationEntity({
    required this.id,
    required this.customerId,
    required this.subject,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.messages = const [],
  });

  ConversationEntity copyWith({
    String? id,
    String? customerId,
    String? subject,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ChatMessageEntity>? messages,
  }) {
    return ConversationEntity(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      subject: subject ?? this.subject,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      messages: messages ?? this.messages,
    );
  }
}
