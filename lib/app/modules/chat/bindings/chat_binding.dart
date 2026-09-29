import 'package:get/get.dart';
import '../../../data/datasources/chat_remote_datasource.dart';
import '../../../data/datasources/pusher_remote_datasource.dart';
import '../../../data/repositories/chat_repository_impl.dart';
import '../../../domain/repositories/chat_repository.dart';
import '../../../domain/usecases/chat/get_conversations_usecase.dart';
import '../../../domain/usecases/chat/get_messages_usecase.dart';
import '../../../domain/usecases/chat/manage_pusher_usecase.dart';
import '../../../domain/usecases/chat/send_message_usecase.dart';
import '../../../domain/usecases/chat/subscribe_to_messages_stream_usecase.dart';
import '../controllers/chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    // Data Sources
    Get.lazyPut<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImpl(),
    );
    Get.lazyPut<PusherRemoteDataSource>(
      () => PusherRemoteDataSourceImpl(),
    );

    // Repository
    Get.lazyPut<ChatRepository>(
      () => ChatRepositoryImpl(
        remoteDataSource: Get.find<ChatRemoteDataSource>(),
        pusherRemoteDataSource: Get.find<PusherRemoteDataSource>(),
      ),
    );

    // Use Cases
    Get.lazyPut<GetConversationsUseCase>(
      () => GetConversationsUseCase(Get.find<ChatRepository>()),
    );
    Get.lazyPut<GetMessagesUseCase>(
      () => GetMessagesUseCase(Get.find<ChatRepository>()),
    );
    Get.lazyPut<SendMessageUseCase>(
      () => SendMessageUseCase(Get.find<ChatRepository>()),
    );
    Get.lazyPut<ManagePusherUseCase>(
      () => ManagePusherUseCase(Get.find<ChatRepository>()),
    );
    Get.lazyPut<SubscribeToMessagesStreamUseCase>(
      () => SubscribeToMessagesStreamUseCase(Get.find<ChatRepository>()),
    );

    // Controller
    Get.lazyPut<ChatController>(
      () => ChatController(
        getConversationsUseCase: Get.find<GetConversationsUseCase>(),
        getMessagesUseCase: Get.find<GetMessagesUseCase>(),
        sendMessageUseCase: Get.find<SendMessageUseCase>(),
        managePusherUseCase: Get.find<ManagePusherUseCase>(),
        subscribeToMessagesStreamUseCase: Get.find<SubscribeToMessagesStreamUseCase>(),
      ),
    );
  }
}
