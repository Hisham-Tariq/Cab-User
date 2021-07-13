import 'package:async_button_builder/async_button_builder.dart';
import 'package:driving_app_its/constants.dart';
import 'package:driving_app_its/customization/colors.dart';
import 'package:driving_app_its/customization/customization.dart';
import 'package:driving_app_its/screens/OTPScreen.dart';
import 'package:driving_app_its/screens/UserInfoGetterScreen.dart';
import 'package:driving_app_its/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PhoneInputScreen extends StatefulWidget {
  //Unique Form Identification key
  @override
  _PhoneInputScreenState createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final _formKey = GlobalKey<FormState>();

  final phoneController = TextEditingController();

  ButtonState buttonState = ButtonState.idle();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                      Text(
                        'Phone Number',
                        style: GoogleFonts.catamaran(
                          color: Colors.black45,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      TextFormField(
                        controller: phoneController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Must provide the phone number';
                          } else if (value.length < 10 || value.length > 11) {
                            return 'Invalid Phone Number';
                          }
                          return null;
                        },
                        cursorColor: AppColors.primary,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 4),
                      Center(
                        child: AsyncAnimatedButton(
                          stateColors: {
                            AsyncButtonState.orElse: AppColors.primary,
                            AsyncButtonState.fail: Colors.red,
                          },
                          stateTexts: {
                            AsyncButtonState.idle: 'Continue',
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
                          onPressed: verifyPhoneNumber,
                        ),
                      ),
                      //TODO: Update my Own Animated Button to Create
                      // The way i wanted
                      // AnimatedButton(
                      //   stateButtons: {
                      //     AnimatedButtonState.idle: FullTextButton(
                      //       onPressed: () async {
                      //         if (!_formKey.currentState!.validate()) return;
                      //         verifyPhoneNumber();
                      //       },
                      //       text: 'Continue',
                      //     ),
                      //     AnimatedButtonState.loading: Center(
                      //       child: LoadingButton(),
                      //     ),
                      //     AnimatedButtonState.success: FullTextButton(
                      //       onPressed: () {},
                      //       text: 'Success',
                      //     ),
                      //     AnimatedButtonState.fail: FullTextButton(
                      //       onPressed: () {},
                      //       text: 'Fail',
                      //       buttonColor: Colors.red,
                      //     ),
                      //   },
                      //   currentState: this.buttonState,
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

  AsyncButtonGenerator(text, icon) {
    return Container(
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          SizedBox(width: 8),
          Text(
            text,
            style: AppTextStyle.button,
          ),
        ],
      ),
    );
  }

  Future<void> verifyPhoneNumber() async {
    if (!_formKey.currentState!.validate()) return;
    this.setState(() {
      this.buttonState = ButtonState.loading();
    });
    var phoneNumber = '+92${phoneController.text}';

    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Automatic handling of the SMS code on Android devices.
        await auth.signInWithCredential(credential);
        this.setState(() {
          this.buttonState = ButtonState.success();
          Future.delayed(Duration(seconds: 1)).then((value) {
            Get.to(() => UserInfoGetterScreen());
          });
        });
      },
      codeSent: (String verificationId, int? forceResendingToken) {
        // Called when Code has been sended
        this.setState(() {
          this.buttonState = ButtonState.success();
          Future.delayed(Duration(seconds: 1)).then((value) {
            Get.to(
              () => OTPScreen(
                verificationId: verificationId,
                forceResendingToken: forceResendingToken,
              ),
            );
          });
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        //  Called when app will fail to automatically get the code
        print('Auto Retrieval Finish');
      },
      verificationFailed: (FirebaseAuthException error) {
        this.setState(() {
          this.buttonState = ButtonState.error();
          Future.delayed(Duration(seconds: 2)).then((value) {
            this.setState(() {
              this.buttonState = ButtonState.idle();
            });
          });
        });
        // Called when Verification failed
        // 1. Invalid Phone
        // 2. Sms Quota Finished
        if (error.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
    );
  }
}

//TODO: Current Page Tasks
//TODO: 1. Task Name                              Status
//TODO: 2. Validate Phone Number                  Status
//TODO: 3. Make Style Consistent                  Status
//TODO: 4. Keep Single Source of Truth            Status
