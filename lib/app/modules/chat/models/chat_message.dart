enum ChatSender { store, user }

class ChatMessage {
  final String text;
  final ChatSender sender;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.sender,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}
