import '../../repositories/chat_repository.dart';

class ManagePusherUseCase {
  final ChatRepository repository;

  ManagePusherUseCase(this.repository);

  Future<void> initPusher({String? apiKey, String? cluster, String? authEndpoint}) {
    return repository.initPusher(
      apiKey: apiKey,
      cluster: cluster,
      authEndpoint: authEndpoint,
    );
  }

  Future<void> connect() {
    return repository.connectPusher();
  }

  Future<void> disconnect() {
    return repository.disconnectPusher();
  }

  Future<void> subscribeChannel(String channelName, {Function(dynamic event)? onEvent}) {
    return repository.subscribeChannel(channelName, onEvent: onEvent);
  }

  Future<void> unsubscribeChannel(String channelName) {
    return repository.unsubscribeChannel(channelName);
  }

  Stream<dynamic> getEventStream() {
    return repository.getPusherEventStream();
  }

  Stream<String> getConnectionStateStream() {
    return repository.getPusherConnectionStateStream();
  }
}
