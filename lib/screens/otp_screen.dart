import '../controller/controller.dart';
import '../customization/customization.dart';
// import '../screens/NewTripBooking/new_trip_booking_screen.dart';
// import '../screens/user_info_getter_screen.dart';
import '../widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import '../routes/paths.dart';

class OTPScreen extends StatefulWidget {
  late final String verificationId;
  late final int? forceResendingToken;
  late final bool isNewUser;

  OTPScreen({
    Key? key,
  }) : super(key: key) {
    print(Get.arguments);
    verificationId = Get.arguments['verificationId'];
    isNewUser = Get.arguments['isNewUser'];
    forceResendingToken = Get.arguments['forceResendingToken'];
    // print(this.verificationId);
  }

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _formKey = GlobalKey<FormState>();

  // final otpController = TextEditingController();
  String otpCode = '';
  ButtonState buttonState = ButtonState.idle;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 120),
                const AppName(),
                const AppTagLine(),
                const SizedBox(height: 100),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'OTP Code',
                        style: GoogleFonts.catamaran(
                          color: Colors.black45,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextField(
                        onChanged: (value) {
                          print(value);
                          // print(otpController.text);
                          otpCode = value;
                          if (value.length == 6) {
                            Future.delayed(Duration(milliseconds: 10))
                                .then((value) {
                              verifyOTPCode();
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: ProgressButton.icon(
                              iconedButtons: const {
                                ButtonState.idle: IconedButton(
                                  text: "Verify",
                                  icon: Icon(Icons.arrow_forward,
                                      color: Colors.white),
                                  color: AppColors.primary,
                                ),
                                ButtonState.loading: IconedButton(
                                  text: "Loading",
                                  color: AppColors.primary,
                                ),
                                ButtonState.fail: IconedButton(
                                  text: "Failed",
                                  icon: Icon(Icons.cancel, color: Colors.white),
                                  color: AppColors.error,
                                ),
                                ButtonState.success: IconedButton(
                                  text: "Success",
                                  icon: Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                  ),
                                  color: AppColors.primary,
                                )
                              },
                              onPressed: verifyOTPCode,
                              state: buttonState,
                              progressIndicator:
                                  const CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.green),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onSuccessfullyAuth() {
    if (widget.isNewUser) {
      Get.offAllNamed(AppPaths.userInfo);
    } else {
      var controller = Get.find<UserController>();
      controller
          .readCurrentUser()
          .then((_) => Get.offAllNamed(AppPaths.tripBooking));
    }
  }

  Future<void> verifyOTPCode() async {
    setState(() {
      buttonState = ButtonState.loading;
    });
    // var otpCode = otpController.text;
    FirebaseAuth auth = FirebaseAuth.instance;

    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: otpCode,
    );

    // Sign the user in (or link) with the credential
    try {
      await auth.signInWithCredential(credential);
      setState(() {
        buttonState = ButtonState.success;
      });
      await Future.delayed(const Duration(seconds: 1));
      _onSuccessfullyAuth();
    } catch (e) {
      if (FirebaseAuth.instance.currentUser != null) {
        _onSuccessfullyAuth();
      } else {
        print('Error: $e');
        Get.snackbar('Error', '$e');
        setState(() {
          buttonState = ButtonState.fail;
          Future.delayed(const Duration(seconds: 1)).then((value) {
            setState(() {
              buttonState = ButtonState.idle;
            });
          });
        });
      }
      setState(() {
        buttonState = ButtonState.fail;
        Future.delayed(const Duration(seconds: 1)).then((value) {
          setState(() {
            buttonState = ButtonState.idle;
          });
        });
      });
    }
  }
}
