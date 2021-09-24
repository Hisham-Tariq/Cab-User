import 'dart:io';

import '../controller/controller.dart';
import '../widgets/AppName.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../routes/paths.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    askRiderToGrantLocationPermission().then((value) {
      if (value) {
        if (_isUserNotLoggedIn) {
          Future.delayed(const Duration(seconds: 1))
              .then((_) => Get.offAllNamed(AppPaths.signupLogin));
        } else {
          // User is Signed In
          var controller = Get.find<UserController>();
          controller.userWithPhoneNumberIsExist(_userPhoneNumber).then((value) {
            if (value) {
              //  Rider Already Filled his Profile
              controller.readCurrentUser().then((_) {
                print(controller.user.firstName);
                Get.offAllNamed(AppPaths.tripBooking);
              });
            } else {
              //  Rider didn't provide his Details
              controller.user.phoneNumber = _userPhoneNumber;
              controller.user.id = _userUID;
              Get.offAllNamed(AppPaths.userInfo);
            }
          });
        }
      } else {
        if (Platform.isAndroid) exit(0);
      }
    });
  }

  get _isUserNotLoggedIn => FirebaseAuth.instance.currentUser == null;

  get _userPhoneNumber => FirebaseAuth.instance.currentUser!.phoneNumber;

  get _userUID => FirebaseAuth.instance.currentUser!.uid;

  Future<bool> askRiderToGrantLocationPermission() async {
    // await FirebaseAuth.instance.signOut();
    if (!(await Permission.locationWhenInUse.request().isGranted)) {
      Get.snackbar(
        'Location',
        'Location permission must be granted in order to use the app',
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return const Material(
      color: Colors.white,
      child: Center(
        child: AppName(),
      ),
    );
  }
}
