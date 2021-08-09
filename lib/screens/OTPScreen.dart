// import 'package:async_button_builder/async_button_builder.dart';
import 'package:driving_app_its/customization/customization.dart';
import 'package:driving_app_its/screens/HomeScreen/HomeScreen.dart';
import 'package:driving_app_its/screens/UserInfoGetterScreen.dart';
import 'package:driving_app_its/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OTPScreen extends StatefulWidget {
  final String verificationId;
  final int? forceResendingToken;
  final bool isNewUser;

  OTPScreen({
    Key? key,
    required this.verificationId,
    this.forceResendingToken,
    this.isNewUser = true,
  }) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _formKey = GlobalKey<FormState>();

  // final otpController = TextEditingController();
  String otpCode = '';
  ButtonState buttonState = ButtonState.idle;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SmsAutoFill().listenForCode;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 120),
                AppName(),
                AppTagLine(),
                SizedBox(height: 100),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //TODO: Add LabelStyle in TextStyle File
                      Text(
                        'OTP Code',
                        style: GoogleFonts.catamaran(
                          color: Colors.black45,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      TextFieldPinAutoFill(
                        codeLength: 6,
                        onCodeChanged: (value) {
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
                      SizedBox(height: 4),
                      // Center(
                      //   child: AsyncAnimatedButton(
                      //     stateColors: {
                      //       AsyncButtonState.orElse: AppColors.primary,
                      //       AsyncButtonState.fail: Colors.red,
                      //     },
                      //     stateTexts: {
                      //       AsyncButtonState.idle: 'Verify',
                      //       AsyncButtonState.success: 'Success',
                      //       AsyncButtonState.fail: 'Fail',
                      //     },
                      //     stateIcons: {
                      //       AsyncButtonState.idle: Icons.arrow_right_alt,
                      //       AsyncButtonState.success:
                      //           Icons.check_circle_outline_rounded,
                      //       AsyncButtonState.fail: Icons.cancel_outlined,
                      //     },
                      //     buttonState: buttonState,
                      //     onPressed: verifyOTPCode,
                      //   ),
                      // ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: ProgressButton.icon(
                              iconedButtons: {
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
                              onPressed: this.verifyOTPCode,
                              state: this.buttonState,
                              progressIndicator: CircularProgressIndicator(
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

  Future<void> verifyOTPCode() async {
    // if (!_formKey.currentState!.validate()) return;
    this.setState(() {
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
      this.setState(() {
        buttonState = ButtonState.success;
      });
      await Future.delayed(Duration(seconds: 1));
      // Remove the Listen to OTP Code
      await SmsAutoFill().unregisterListener();
      if (widget.isNewUser) {
        Get.to(() => UserInfoGetterScreen());
      } else {
        Get.off(() => HomeScreen());
      }
    } catch (e) {
      this.setState(() {
        buttonState = ButtonState.fail;
        Future.delayed(Duration(seconds: 1)).then((value) {
          this.setState(() {
            buttonState = ButtonState.idle;
          });
        });
      });
    }
  }
}
