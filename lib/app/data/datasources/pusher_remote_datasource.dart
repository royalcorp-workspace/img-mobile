import 'dart:async';
import 'package:dio/dio.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import '../../core/helper/helper.dart';
import '../../core/utils/constants/pusher_constant.dart';
import '../../core/utils/log/logger.dart';

abstract class PusherRemoteDataSource {
  Future<void> init({
    String? apiKey,
    String? cluster,
    String? authEndpoint,
    Map<String, String>? authHeaders,
  });
  Future<void> connect();
  Future<void> disconnect();
  Future<void> subscribe(String channelName, {Function(PusherEvent event)? onEvent});
  Future<void> unsubscribe(String channelName);
  Stream<PusherEvent> get eventStream;
  Stream<String> get connectionStateStream;
}

class PusherRemoteDataSourceImpl implements PusherRemoteDataSource {
  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();
  final StreamController<PusherEvent> _eventStreamController = StreamController<PusherEvent>.broadcast();
  final StreamController<String> _connectionStateController = StreamController<String>.broadcast();
  final Map<String, Function(PusherEvent event)> _channelEventCallbacks = {};
  bool _isInitialized = false;

  @override
  Stream<PusherEvent> get eventStream => _eventStreamController.stream;

  @override
  Stream<String> get connectionStateStream => _connectionStateController.stream;

  @override
  Future<void> init({
    String? apiKey,
    String? cluster,
    String? authEndpoint,
    Map<String, String>? authHeaders,
  }) async {
    if (_isInitialized) return;

    final key = apiKey ?? PusherConstant.apiKey;
    final cl = cluster ?? PusherConstant.cluster;
    final endpoint = authEndpoint ?? PusherConstant.authEndpoint;

    try {
      await _pusher.init(
        apiKey: key,
        cluster: cl,
        authEndpoint: endpoint,
        onEvent: _onEvent,
        onSubscriptionSucceeded: _onSubscriptionSucceeded,
        onSubscriptionError: _onSubscriptionError,
        onError: _onError,
        onConnectionStateChange: _onConnectionStateChange,
        onAuthorizer: _onAuthorizer,
      );
      _isInitialized = true;
      logger.info('Pusher initialized successfully [Key: $key, Cluster: $cl]');
    } catch (e, stack) {
      logger.severe('Failed to initialize Pusher: $e', e, stack);
      rethrow;
    }
  }

  dynamic _onAuthorizer(String channelName, String socketId, dynamic options) async {
    try {
      logger.info('Pusher authorizer called for $channelName with socketId $socketId');
      final dio = Dio();
      final headers = Map<String, dynamic>.from(Helper.getHeaders());
      
      final response = await dio.post(
        PusherConstant.authEndpoint,
        data: {
          'socket_id': socketId,
          'channel_name': channelName,
        },
        options: Options(
          headers: headers,
          contentType: Headers.formUrlEncodedContentType,
        ),
      );
      logger.info('Pusher authorization succeeded for $channelName');
      return response.data;
    } catch (e, stack) {
      logger.severe('Pusher onAuthorizer error for $channelName: $e', e, stack);
      return null;
    }
  }

  @override
  Future<void> connect() async {
    try {
      if (!_isInitialized) {
        await init();
      }
      await _pusher.connect();
      logger.info('Pusher connect requested');
    } catch (e, stack) {
      logger.severe('Failed to connect Pusher: $e', e, stack);
      rethrow;
    }
  }

  @override
  Future<void> disconnect() async {
    try {
      await _pusher.disconnect();
      logger.info('Pusher disconnected');
    } catch (e, stack) {
      logger.severe('Failed to disconnect Pusher: $e', e, stack);
      rethrow;
    }
  }

  @override
  Future<void> subscribe(String channelName, {Function(PusherEvent event)? onEvent}) async {
    try {
      if (!_isInitialized) {
        await init();
      }
      if (onEvent != null) {
        _channelEventCallbacks[channelName] = onEvent;
      }
      await _pusher.subscribe(channelName: channelName);
      logger.info('Subscribed to Pusher channel: $channelName');
    } catch (e, stack) {
      logger.severe('Failed to subscribe to channel $channelName: $e', e, stack);
      rethrow;
    }
  }

  @override
  Future<void> unsubscribe(String channelName) async {
    try {
      _channelEventCallbacks.remove(channelName);
      await _pusher.unsubscribe(channelName: channelName);
      logger.info('Unsubscribed from Pusher channel: $channelName');
    } catch (e, stack) {
      logger.severe('Failed to unsubscribe from channel $channelName: $e', e, stack);
      rethrow;
    }
  }

  void _onEvent(PusherEvent event) {
    logger.info('Pusher Event received: channel=${event.channelName}, event=${event.eventName}, data=${event.data}');
    if (!_eventStreamController.isClosed) {
      _eventStreamController.add(event);
    }
    if (_channelEventCallbacks.containsKey(event.channelName)) {
      _channelEventCallbacks[event.channelName]!(event);
    }
  }

  void _onSubscriptionSucceeded(String channelName, dynamic data) {
    logger.info('Subscription Succeeded to $channelName data: $data');
  }

  void _onSubscriptionError(String message, dynamic error) {
    logger.warning('Subscription Error: $message error: $error');
  }

  void _onError(String message, int? code, dynamic error) {
    logger.severe('Pusher Error: $message (code: $code) error: $error');
  }

  void _onConnectionStateChange(String currentState, String previousState) {
    logger.info('Pusher Connection changed from $previousState to $currentState');
    if (!_connectionStateController.isClosed) {
      _connectionStateController.add(currentState);
    }
  }
}
