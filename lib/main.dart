import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/FCMConfiguration/fcm_configuration.dart';
import 'app/data/services/dependency_injection.dart';
import 'app/data/services/theme_service.dart';
import 'app/data/services/translations_service.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/ui/customization/customization.dart';
import 'app/ui/theme/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  DependecyInjection.init();

  FirebaseMessaging.onMessage.listen(firebaseForegroundMessage);
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessageHandler);
  FirebaseMessaging.instance.requestPermission();
  FirebaseMessaging.onMessageOpenedApp.listen(firebaseOnMessageClicked,
      onError: (error) {
    print('Error: $error');
  }, onDone: () {
    print('Done Message');
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Cab',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      darkTheme: Themes().darkTheme,
      themeMode: ThemeService().getThemeMode(),
      translations: Translation(),
      locale: const Locale('en'),
      fallbackLocale: const Locale('en'),
      initialRoute: AppRoutes.SPLASH,
      unknownRoute: AppPages.unknownRoutePage,
      getPages: AppPages.pages,
    );
  }
}
