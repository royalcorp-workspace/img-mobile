import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static String? serverToken;

  static const _key = 'server_token';
  static final _secure = const FlutterSecureStorage();

  static Future<void> init() async {
    try {
      serverToken = await _secure.read(key: _key);
    } catch (e) {
      if (kDebugMode) print('TokenStorage init error: $e');
    }
  }

  static Future<void> save(String token) async {
    serverToken = token;
    await _secure.write(key: _key, value: token);
  }

  static Future<void> clear() async {
    serverToken = null;
    await _secure.delete(key: _key);
  }
}
