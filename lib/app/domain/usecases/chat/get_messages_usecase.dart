import '../../entities/chat_message_entity.dart';
import '../../repositories/chat_repository.dart';

class GetMessagesUseCase {
  final ChatRepository repository;

  GetMessagesUseCase(this.repository);

  Future<List<ChatMessageEntity>> call(String conversationId) {
    return repository.getMessages(conversationId);
  }
}
