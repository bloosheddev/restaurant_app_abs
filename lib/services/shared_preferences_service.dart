import 'package:restaurant_app/models/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _preferences;

  SharedPreferencesService(this._preferences);

  static const String _keyDarkMode = "MY_DARK_MODE";
  static const String _keyNotification = "MY_NOTIFICATION";

  Future<void> saveSettingValue(Settings settings) async {
    try {
      await _preferences.setBool(_keyDarkMode, settings.darkModeEnable);
      await _preferences.setBool(_keyNotification, settings.notificationEnable);
    } catch (e) {
      throw Exception("Shared preferences cannot save the settings value.");
    }
  }

  Settings getSettingValue() {
    return Settings(
      darkModeEnable: _preferences.getBool(_keyDarkMode) ?? false,
      notificationEnable: _preferences.getBool(_keyNotification) ?? false,
    );
  }
}
