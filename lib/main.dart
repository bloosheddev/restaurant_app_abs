import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/local/local_database_service.dart';
import 'package:restaurant_app/provider/detail/favorite_icon_provider.dart';
import 'package:restaurant_app/provider/favorite/local_database_provider.dart';
import 'package:restaurant_app/provider/main/index_nav_provider.dart';
import 'package:restaurant_app/provider/detail/restaurant_detail_provider.dart';
import 'package:restaurant_app/provider/home/restaurant_list_provider.dart';
import 'package:restaurant_app/provider/notification/schedule_notification_provider.dart';
import 'package:restaurant_app/provider/settings/shared_preferences_provider.dart';
import 'package:restaurant_app/provider/settings/state/darkmode_state_provider.dart';
import 'package:restaurant_app/provider/settings/state/restaurant_notification_state_provider.dart';
import 'package:restaurant_app/screen/favorite/favorite_screen.dart';
import 'package:restaurant_app/screen/main_screen.dart';
import 'package:restaurant_app/services/schedule_notification_service.dart';
import 'package:restaurant_app/services/shared_preferences_service.dart';
import 'package:restaurant_app/static/navigation_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => ApiServices()),
        ChangeNotifierProvider(
          create: (context) =>
              RestaurantListProvider(context.read<ApiServices>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              RestaurantDetailProvider(context.read<ApiServices>()),
        ),
        Provider(create: (context) => SharedPreferencesService(prefs)),
        ChangeNotifierProvider(
          create: (context) => SharedPreferencesProvider(
            context.read<SharedPreferencesService>(),
          ),
        ),
        ChangeNotifierProvider(create: (context) => DarkmodeStateProvider()),
        ChangeNotifierProvider(
          create: (context) => RestaurantNotificationStateProvider(),
        ),
        ChangeNotifierProvider(create: (context) => IndexNavProvider()),
        Provider(create: (context) => LocalDatabaseService()),
        ChangeNotifierProvider(
          create: (context) =>
              LocalDatabaseProvider(context.read<LocalDatabaseService>()),
        ),
        ChangeNotifierProvider(create: (context) => FavoriteIconProvider()),
        Provider(
          create: (context) => ScheduleNotificationService()
            ..init()
            ..configureLocalTimeZone(),
        ),
        ChangeNotifierProvider(
          create: (context) => ScheduleNotificationProvider(
            context.read<ScheduleNotificationService>(),
          )..requestPermissions(),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    _requestPermission();

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
    return Consumer2<
      DarkmodeStateProvider,
      RestaurantNotificationStateProvider
    >(
      builder:
          (
            context,
            darkModeProvider,
            restaurantNotificationStateProvider,
            child,
          ) {
            final bool isDarkMode = darkModeProvider.darkModeState;

            setNotificationSchedule();

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                fontFamily: GoogleFonts.poppins().fontFamily,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.orange,
                  brightness: Brightness.light,
                ),
              ),
              darkTheme: ThemeData(
                fontFamily: GoogleFonts.poppins().fontFamily,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.orange,
                  brightness: Brightness.dark,
                ),
              ),
              themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
              title: 'Restaurant App',
              initialRoute: NavigationRoute.mainRoute.name,
              routes: {
                NavigationRoute.mainRoute.name: (context) => MainScreen(),
                NavigationRoute.favoriteRoute.name: (context) =>
                    FavoriteScreen(),
              },
            );
          },
    );
  }

  Future<void> _requestPermission() async {
    context.read<ScheduleNotificationProvider>().requestPermissions();
  }

  void setNotificationSchedule() async {
    final localNotificationProvider = context
        .read<ScheduleNotificationProvider>();
    final restaurantNotificationState = context
        .read<RestaurantNotificationStateProvider>();
    int notificationId = 0;

    if (restaurantNotificationState.restaurantNotificationState == true) {
      print('enabled!');
      return await _scheduleDailyElevenAMNotification();
    } else {
      print('disable');
      return localNotificationProvider.cancelNotification(1);
    }
  }

  Future<void> _scheduleDailyElevenAMNotification() async {
    context
        .read<ScheduleNotificationProvider>()
        .scheduleDailyElevenAMNotification();
  }
}
