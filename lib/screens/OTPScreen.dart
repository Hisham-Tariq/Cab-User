import 'package:async_button_builder/async_button_builder.dart';
import 'package:driving_app_its/customization/customization.dart';
import 'package:driving_app_its/screens/UserInfoGetterScreen.dart';
import 'package:driving_app_its/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class OTPScreen extends StatefulWidget {
  final String verificationId;
  final int? forceResendingToken;

  OTPScreen({
    Key? key,
    required this.verificationId,
    this.forceResendingToken,
  }) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _formKey = GlobalKey<FormState>();

  final otpController = TextEditingController();

  ButtonState buttonState = ButtonState.idle();

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
                      TextFormField(
                        controller: otpController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          return value!.isEmpty ? 'Invalid Value' : null;
                        },
                      ),
                      SizedBox(height: 4),
                      Center(
                        child: AsyncAnimatedButton(
                          stateColors: {
                            AsyncButtonState.orElse: AppColors.primary,
                            AsyncButtonState.fail: Colors.red,
                          },
                          stateTexts: {
                            AsyncButtonState.idle: 'Verify',
                            AsyncButtonState.success: 'Success',
                            AsyncButtonState.fail: 'Fail',
                          },
                          stateIcons: {
                            AsyncButtonState.idle: Icons.arrow_right_alt,
                            AsyncButtonState.success:
                                Icons.check_circle_outline_rounded,
                            AsyncButtonState.fail: Icons.cancel_outlined,
                          },
                          buttonState: buttonState,
                          onPressed: verifyOTPCode,
                        ),
                      ),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: TextButton(
                      //         onPressed: () {
                      //           if (!_formKey.currentState!.validate()) return;
                      //           verifyOTPCode();
                      //         },
                      //         child: Text(
                      //           'Verify',
                      //           style: GoogleFonts.catamaran(
                      //             fontWeight: FontWeight.w800,
                      //             color: Colors.white,
                      //           ),
                      //         ),
                      //         style: TextButton.styleFrom(
                      //           backgroundColor: Colors.green,
                      //           minimumSize: Size(100, 45),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
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
    if (!_formKey.currentState!.validate()) return;
    this.setState(() {
      buttonState = ButtonState.loading();
    });
    var otpCode = otpController.text;
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
        buttonState = ButtonState.success();
      });
      await Future.delayed(Duration(seconds: 1));
      Get.to(() => UserInfoGetterScreen());
    } catch (e) {
      this.setState(() {
        buttonState = ButtonState.error();
        Future.delayed(Duration(seconds: 1)).then((value) {
          this.setState(() {
            buttonState = ButtonState.idle();
          });
        });
      });
    }
  }
}
