import 'package:flutter/widgets.dart';

class DarkmodeStateProvider extends ChangeNotifier {
  //
  bool _darkModeState = false;

  bool get darkModeState => _darkModeState;

  set darkModeState(bool value) {
    _darkModeState = value;
    notifyListeners();
  }
}
