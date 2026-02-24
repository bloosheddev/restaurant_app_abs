import 'package:flutter/material.dart';
import 'package:restaurant_app/models/settings.dart';
import 'package:restaurant_app/services/shared_preferences_service.dart';

class SharedPreferencesProvider extends ChangeNotifier {
  final SharedPreferencesService _service;

  SharedPreferencesProvider(this._service);

  String _message = "";
  String get message => _message;

  Settings? _setting;
  Settings? get setting => _setting;

  Future<void> saveSettingValue(Settings value) async {
    try {
      await _service.saveSettingValue(value);
      _message = "Your data is saved";
    } catch (e) {
      _message = "Failed to save your data";
    }
    notifyListeners();
  }

  void getSettingValue() async {
    try {
      _setting = _service.getSettingValue();
      _message = "Data successfully retrieved";
    } catch (e) {
      _message = "Failed to get your data";
    }
    notifyListeners();
  }
}
