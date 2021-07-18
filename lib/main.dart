import 'package:driving_app_its/customization/colors.dart';
import 'package:driving_app_its/customization/customization.dart';
import 'package:driving_app_its/screens/screens.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: Colors.white,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.primary,
        ),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: EdgeInsets.symmetric(horizontal: 15),
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary, width: 2),
            borderRadius: BorderRadius.circular(999.0),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: Colors.white,
            backgroundColor: AppColors.primary,
            textStyle: AppTextStyle.button,
            minimumSize: Size(150, 45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: SplashScreen(),
      ),
    );
  }
}
// Theming
// Primary Color: Colors.green
// BackgroundColor; Colors.white
//
