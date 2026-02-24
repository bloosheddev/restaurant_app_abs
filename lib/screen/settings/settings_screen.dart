import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/models/settings.dart';
import 'package:restaurant_app/provider/notification/schedule_notification_provider.dart';
import 'package:restaurant_app/provider/settings/shared_preferences_provider.dart';
import 'package:restaurant_app/provider/settings/state/darkmode_state_provider.dart';
import 'package:restaurant_app/provider/settings/state/restaurant_notification_state_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();

    final sharedPreferencesProvider = context.read<SharedPreferencesProvider>();

    final darkmodeStateProvider = context.read<DarkmodeStateProvider>();
    final restaurantNotificationStateProvider = context
        .read<RestaurantNotificationStateProvider>();

    Future.microtask(() async {
      sharedPreferencesProvider.getSettingValue();
      final setting = sharedPreferencesProvider.setting;

      if (setting != null) {
        darkmodeStateProvider.darkModeState = setting.darkModeEnable;
        restaurantNotificationStateProvider.restaurantNotificationState =
            setting.notificationEnable;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<DarkmodeStateProvider>(
              builder: (context, provider, child) {
                final bool state = provider.darkModeState;

                return SwitchListTile(
                  title: Text('Dark Mode'),
                  subtitle: Text('Enable dark mode accent'),
                  value: state,
                  onChanged: (value) {
                    value = state;
                    provider.darkModeState = !value;

                    saveSettings();
                  },
                );
              },
            ),
            Consumer<RestaurantNotificationStateProvider>(
              builder: (context, provider, child) {
                final bool state = provider.restaurantNotificationState;

                return Consumer<ScheduleNotificationProvider>(
                  builder:
                      (
                        BuildContext context,
                        ScheduleNotificationProvider value,
                        Widget? child,
                      ) {
                        return SwitchListTile(
                          title: Text('Restaurant Notification'),
                          subtitle: Text('Enable lunch notification at 11:00'),
                          value: state,
                          onChanged: (value) {
                            value = state;
                            provider.restaurantNotificationState = !value;

                            saveSettings();
                          },
                        );
                      },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void saveSettings() async {
    final sharedPreferencesProvider = context.read<SharedPreferencesProvider>();

    final restaurantNotificationState = context
        .read<RestaurantNotificationStateProvider>()
        .restaurantNotificationState;

    final darkModeState = context.read<DarkmodeStateProvider>().darkModeState;

    final Settings settings = Settings(
      darkModeEnable: darkModeState,
      notificationEnable: restaurantNotificationState,
    );

    await sharedPreferencesProvider.saveSettingValue(settings);
  }
}
