import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class LocalStorageService {
  // Private constructor to create an instance with SharedPreferences.
  LocalStorageService._internal(this._prefs);

  // Stores the SharedPreferences instance used to read and write data.
  final SharedPreferences _prefs;

  // Caches the Future so multiple calls reuse the same initialization.
  static Future<LocalStorageService>? _instanceFuture;

  // Returns the existing initialization Future or starts initialization.
  static Future<LocalStorageService> getInstance() {
    return _instanceFuture ??= _createInstance();
  }

  // Creates the service instance and resets initialization if it fails.
  static Future<LocalStorageService> _createInstance() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Creates and returns the LocalStorageService instance.
      return LocalStorageService._internal(prefs);
    } catch (_) {
      // Allows initialization to be retried after a failure.
      _instanceFuture = null;
      rethrow;
    }
  }
  Future<void> saveString(String key, String value) => _prefs.setString(key, value);
  String? getString(String key) => _prefs.getString(key);

  Future<void> saveBool(String key, bool value) =>
      _prefs.setBool(key, value);

  bool getBool(String key, {bool defaultValue = false}) =>
      _prefs.getBool(key) ?? defaultValue;

  Future<void> saveInt(String key, int value) =>
      _prefs.setInt(key, value);

  int? getInt(String key) => _prefs.getInt(key);


  Future<void> saveObject(String key, Map<String, dynamic> json) =>
      _prefs.setString(key, jsonEncode(json));

  Map<String, dynamic>? getObject(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return null;

    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<void> remove(String key) => _prefs.remove(key);

  Future<void> clearAll() => _prefs.clear();
}
