import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum StorageType { shared }

class AppSharedPrefs extends GetxService {
  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> write(String key, String value) async {
    await _prefs.setString(key, value);
  }

  Future<String?> read(String key) async {
    return _prefs.getString(key);
  }

  Future<void> delete(
    String key, {
    StorageType type = StorageType.shared,
  }) async {
    switch (type) {
      case StorageType.shared:
        await _prefs.remove(key);
        break;
    }
  }

  Future<bool> isContain(
    String key, {
    StorageType type = StorageType.shared,
  }) async {
    switch (type) {
      case StorageType.shared:
        return _prefs.containsKey(key);
    }
  }
}
