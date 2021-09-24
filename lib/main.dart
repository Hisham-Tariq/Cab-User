import 'package:driving_app_its/customization/customization.dart';
import 'package:driving_app_its/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'FCMConfiguration/FCMConfiguration.dart';
import 'bindings/bindings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onMessage.listen(firebaseForegroundMessage);
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessageHandler);
  FirebaseMessaging.instance.requestPermission();
  FirebaseMessaging.onMessageOpenedApp.listen(firebaseOnMessageClicked,
      onError: (error) {
    print('Error: $error');
  }, onDone: () {
    print('Done Message');
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AppBindings(),
      theme: AppTheme.theme,
      initialRoute: '/',
      getPages: routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
