enum SenderType { user, customer, admin, store, unknown }

class ChatMessageEntity {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderType;
  final String text;
  final bool isRead;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ChatMessageEntity({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderType,
    required this.text,
    this.isRead = false,
    this.createdAt,
    this.updatedAt,
  });

  /// Helper getter to check if the message was sent by current user / customer
  bool get isMe =>
      senderType.toLowerCase() == 'user' ||
      senderType.toLowerCase() == 'customer';

  ChatMessageEntity copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? senderType,
    String? text,
    bool? isRead,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChatMessageEntity(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      senderType: senderType ?? this.senderType,
      text: text ?? this.text,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
