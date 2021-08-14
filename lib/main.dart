import 'package:driving_app_its/customization/customization.dart';
import 'package:driving_app_its/screens/screens.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'FCMConfiguration/FCMConfiguration.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onMessage.listen(firebaseForegroundMessage);
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessageHandler);
  FirebaseMessaging.onMessageOpenedApp.listen(firebaseOnMessageClicked);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: SplashScreen(),
      ),
    );
  }
}
