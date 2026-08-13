class PusherConstant {
  PusherConstant._();

  /// Pusher App Key provided by your backend/Pusher dashboard.
  /// Set this to your actual Pusher app key.
  static const String apiKey = String.fromEnvironment(
    'PUSHER_APP_KEY',
    defaultValue: '5c30ca1eb3e64d7d7bf7',
  );

  /// Pusher Cluster (e.g. 'ap1', 'us2', 'eu', etc.)
  static const String cluster = String.fromEnvironment(
    'PUSHER_CLUSTER',
    defaultValue: 'ap1',
  );

  /// Pusher Auth Endpoint for private/presence channels.
  static const String authEndpoint = String.fromEnvironment(
    'PUSHER_AUTH_ENDPOINT',
    defaultValue: 'http://172.16.8.23:8001/api/v1/broadcasting/auth',
  );

  /// Custom host if using custom WebSocket server (e.g., Soketi / Laravel WebSockets)
  static const String? host = null;

  /// Custom port if using custom WebSocket server
  static const int? port = null;

  /// Enable / disable TLS / SSL
  static const bool useTLS = true;
}
