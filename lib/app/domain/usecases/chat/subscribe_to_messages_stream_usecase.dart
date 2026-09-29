import '../../entities/chat_message_entity.dart';
import '../../repositories/chat_repository.dart';

class SubscribeToMessagesStreamUseCase {
  final ChatRepository repository;

  SubscribeToMessagesStreamUseCase(this.repository);

  Stream<ChatMessageEntity> call(String conversationId) {
    return repository.subscribeToMessagesStream(conversationId);
  }
}
