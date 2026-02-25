import 'package:flutter/foundation.dart';
import 'package:restaurant_app/services/schedule_notification_service.dart';

class ScheduleNotificationProvider extends ChangeNotifier {
  final ScheduleNotificationService flutterNotificationService;

  ScheduleNotificationProvider(this.flutterNotificationService);

  bool? _permission = false;
  bool? get permission => _permission;

  Future<void> requestPermissions() async {
    _permission = await flutterNotificationService.requestPermissions();
    notifyListeners();
  }

  void scheduleDailyElevenAMNotification() {
    flutterNotificationService.scheduleDailyElevenAMNotification(id: 0);
  }

  Future<void> cancelNotification(int id) async {
    await flutterNotificationService.cancelNotification(id);
  }
}
