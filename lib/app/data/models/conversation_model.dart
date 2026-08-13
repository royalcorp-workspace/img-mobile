import '../../domain/entities/conversation_entity.dart';
import 'chat_message_model.dart';

class ConversationModel extends ConversationEntity {
  const ConversationModel({
    required super.id,
    required super.customerId,
    required super.subject,
    required super.status,
    super.createdAt,
    super.updatedAt,
    super.messages = const [],
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    List<ChatMessageModel> msgs = [];
    if (json['messages'] != null && json['messages'] is List) {
      msgs = (json['messages'] as List)
          .map((m) => ChatMessageModel.fromJson(m as Map<String, dynamic>))
          .toList();
    }

    return ConversationModel(
      id: json['id'] as String? ?? '',
      customerId: json['customer_id'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      status: json['status'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
      messages: msgs,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'subject': subject,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'messages': messages
          .map((m) => (m is ChatMessageModel) ? m.toJson() : null)
          .where((element) => element != null)
          .toList(),
    };
  }

  ConversationEntity toEntity() {
    return ConversationEntity(
      id: id,
      customerId: customerId,
      subject: subject,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
      messages: messages,
    );
  }
}
