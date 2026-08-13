import '../../entities/conversation_entity.dart';
import '../../repositories/chat_repository.dart';

class GetConversationsUseCase {
  final ChatRepository repository;

  GetConversationsUseCase(this.repository);

  Future<List<ConversationEntity>> call() {
    return repository.getConversations();
  }
}
