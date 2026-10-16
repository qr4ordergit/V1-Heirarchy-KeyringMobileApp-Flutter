import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  LocalStorageService._internal(this._prefs);

  final SharedPreferences _prefs;

  static Future<LocalStorageService>? _instanceFuture;

  static Future<LocalStorageService> getInstance() {
    return _instanceFuture ??= _createInstance();
  }

  static Future<LocalStorageService> _createInstance() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return LocalStorageService._internal(prefs);
    } catch (_) {
      _instanceFuture = null;
      rethrow;
    }
  }

  Future<void> saveString(String key, String value) =>
      _prefs.setString(key, value);

  String? getString(String key) => _prefs.getString(key);

  Future<void> saveBool(String key, bool value) =>
      _prefs.setBool(key, value);

  bool getBool(String key, {bool defaultValue = false}) =>
      _prefs.getBool(key) ?? defaultValue;

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
