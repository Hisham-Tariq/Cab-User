import 'package:driving_app_its/screens/IntroScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  final bool allowNavigate;

  const SplashScreen({Key? key, this.allowNavigate = false}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // print(widget.allowNavigate);
    super.initState();
    // if (widget.allowNavigate)
    // Firebase.initializeApp().then((value) {
    //   Get.off(() => IntroScreen());
    // });
    Future.delayed(Duration(seconds: 2)).then((value) {
      Get.off(() => IntroScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Easy',
              style: GoogleFonts.catamaran(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 50,
                  fontWeight: FontWeight.w900,
                  height: 0,
                ),
              ),
            ),
            Text(
              'Drive',
              style: GoogleFonts.catamaran(
                textStyle: TextStyle(
                  color: Colors.green,
                  fontSize: 50,
                  height: 1.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
