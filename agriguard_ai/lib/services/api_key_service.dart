import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';

class ApiKeyService extends ChangeNotifier {
  static const _storageKey = 'openweather_api_key';

  String? _openWeatherKey;
  bool _loaded = false;

  String? get openWeatherKey => _openWeatherKey;
  bool get isLoaded => _loaded;
  bool get hasWeatherKey =>
      (_openWeatherKey != null && _openWeatherKey!.isNotEmpty) ||
      ApiConfig.openWeatherApiKey.isNotEmpty;

  String get effectiveWeatherKey =>
      _openWeatherKey?.trim().isNotEmpty == true
          ? _openWeatherKey!.trim()
          : ApiConfig.openWeatherApiKey;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _openWeatherKey = prefs.getString(_storageKey);
    _loaded = true;
    notifyListeners();
  }

  Future<void> saveOpenWeatherKey(String key) async {
    final trimmed = key.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, trimmed);
    _openWeatherKey = trimmed;
    notifyListeners();
  }

  Future<void> clearOpenWeatherKey() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    _openWeatherKey = null;
    notifyListeners();
  }
}
