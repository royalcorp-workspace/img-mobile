import 'package:cloud_firestore/cloud_firestore.dart';

enum ChatSender { store, user }

class ChatMessage {
  final String id;
  final String text;
  final ChatSender sender;
  final DateTime timestamp;

  ChatMessage({
    this.id = '',
    required this.text,
    required this.sender,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'sender': sender == ChatSender.user ? 'user' : 'store',
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map, {String id = ''}) {
    final senderStr = map['sender'] as String? ?? 'store';
    final ts = map['timestamp'];
    DateTime time;
    if (ts is Timestamp) {
      time = ts.toDate();
    } else if (ts is DateTime) {
      time = ts;
    } else {
      time = DateTime.now();
    }

    return ChatMessage(
      id: id,
      text: map['text'] as String? ?? '',
      sender: senderStr == 'user' ? ChatSender.user : ChatSender.store,
      timestamp: time,
    );
  }
}
