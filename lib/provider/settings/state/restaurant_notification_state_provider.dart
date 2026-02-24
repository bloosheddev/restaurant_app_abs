import 'package:flutter/widgets.dart';

class RestaurantNotificationStateProvider extends ChangeNotifier {
  //
  bool _restaurantNotificationState = false;

  bool get restaurantNotificationState => _restaurantNotificationState;

  set restaurantNotificationState(bool value) {
    _restaurantNotificationState = value;
    notifyListeners();
  }
}
