import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static String? serverToken;
  static String? refreshToken;
  static String? csrfToken;

  static const _key = 'server_token';
  static const _refreshKey = 'refresh_token';
  static const _csrfKey = 'csrf_token';
  static const _userKey = 'user_data';
  static final _secure = const FlutterSecureStorage();

  static Future<void> init() async {
    try {
      serverToken = await _secure.read(key: _key);
      refreshToken = await _secure.read(key: _refreshKey);
      csrfToken = await _secure.read(key: _csrfKey);
    } catch (e) {
      if (kDebugMode) print('TokenStorage init error: $e');
    }
  }

  static Future<void> save(String token,
      {String? refresh, String? csrf, String? userDataJson}) async {
    serverToken = token;
    await _secure.write(key: _key, value: token);
    if (refresh != null && refresh.isNotEmpty) {
      refreshToken = refresh;
      await _secure.write(key: _refreshKey, value: refresh);
    }
    if (csrf != null) {
      csrfToken = csrf;
      await _secure.write(key: _csrfKey, value: csrf);
    }
    if (userDataJson != null) {
      await _secure.write(key: _userKey, value: userDataJson);
    }
  }

  static Future<String?> getUserData() async {
    try {
      return await _secure.read(key: _userKey);
    } catch (e) {
      return null;
    }
  }

  static Future<void> clear() async {
    serverToken = null;
    refreshToken = null;
    csrfToken = null;
    await _secure.delete(key: _key);
    await _secure.delete(key: _refreshKey);
    await _secure.delete(key: _csrfKey);
    await _secure.delete(key: _userKey);
  }
}
