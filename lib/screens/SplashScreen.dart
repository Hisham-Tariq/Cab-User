import 'package:driving_app_its/controller/controller.dart';
import 'package:driving_app_its/screens/HomeScreen/HomeScreen.dart';
import 'package:driving_app_its/screens/IntroScreen.dart';
import 'package:driving_app_its/screens/screens.dart';
import 'package:driving_app_its/widgets/AppName.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser == null) {
      print('null');
      // User is Not Authenticated
      Future.delayed(Duration(seconds: 1)).then((value) {
        Get.off(() => IntroScreen());
      });
    } else {
      print('not null');
      var controller;
      // User is Authenticated
      if (Get.isRegistered<UserController>()) {
        controller = Get.find<UserController>();
      } else {
        controller = Get.put<UserController>(UserController());
      }
      controller
          .userWithPhoneNumberIsExist(
              FirebaseAuth.instance.currentUser!.phoneNumber as String)
          .then((value) {
        if (value) {
          // All things are clear Navigate to [HomeScreen]
          Get.off(() => HomeScreen());
        } else {
          //User have not completed its profile
          Get.off(() => UserInfoGetterScreen());
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(
        child: AppName(),
      ),
    );
  }
}
