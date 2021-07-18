import 'package:async_button_builder/async_button_builder.dart';
import 'package:driving_app_its/controller/controller.dart';
import 'package:driving_app_its/customization/colors.dart';
import 'package:driving_app_its/customization/customization.dart';
import 'package:driving_app_its/screens/HomeScreen.dart';
import 'package:driving_app_its/screens/OTPScreen.dart';
import 'package:driving_app_its/screens/UserInfoGetterScreen.dart';
import 'package:driving_app_its/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sms_autofill/sms_autofill.dart';

class PhoneInputScreen extends StatefulWidget {
  final bool isNewUser;

  const PhoneInputScreen({Key? key, this.isNewUser = true}) : super(key: key);
  @override
  _PhoneInputScreenState createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  late UserController _userController;
  final _formKey = GlobalKey<FormState>();

  final phoneController = TextEditingController();
  final phoneFocusNode = FocusNode();

  ButtonState buttonState = ButtonState.idle();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!Get.isRegistered<UserController>())
      this._userController = Get.put(UserController());
    else
      this._userController = Get.find<UserController>();
  }

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
                      PhoneFormFieldHint(
                        focusNode: phoneFocusNode,
                        controller: phoneController,
                        decoration: InputDecoration(),
                        // child: TextField(),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Must provide the phone number';
                          } else if (value.contains('+92') &&
                              (value.length < 13 || value.length > 14)) {
                            return 'Invalid Phone Number';
                          } else if (!value.contains('+92') &&
                              (value.length < 10 || value.length > 11)) {
                            return 'Invalid Phone Number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 4),
                      Center(
                        child: AsyncAnimatedButton(
                          stateColors: {
                            AsyncButtonState.orElse: AppColors.primary,
                            AsyncButtonState.fail: AppColors.error,
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

  changeButtonToErrorState() {
    this.setState(() {
      this.buttonState = ButtonState.error();
      Future.delayed(Duration(seconds: 2)).then((value) {
        this.setState(() {
          this.buttonState = ButtonState.idle();
        });
      });
    });
  }

  // Check if the number is provided with +92 if not it will add +92 at start
  String get formatedPhoneNumber => phoneController.text.contains("+92")
      ? phoneController.text
      : '+92${phoneController.text}';

  Future<void> verifyPhoneNumber() async {
    phoneFocusNode.unfocus();
    if (!_formKey.currentState!.validate()) return;
    this.setState(() {
      this.buttonState = ButtonState.loading();
    });
    var phoneNumber = this.formatedPhoneNumber;
    var isExist =
        await this._userController.userWithPhoneNumberIsExist(phoneNumber);
    if (widget.isNewUser && isExist) {
      // User try to register when the phone number already been registered
      print('User With this Phone Number is Already Exist try to Login');
      this.changeButtonToErrorState();
      return;
    } else if (!widget.isNewUser && !isExist) {
      print(
          'User With this Phone Number does not exist, try to register first');
      this.changeButtonToErrorState();
      return;
      // User try to login without first registering the phone number
    }

    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Automatic handling of the SMS code on Android devices.
        await auth.signInWithCredential(credential);

        this.setState(() {
          this.buttonState = ButtonState.success();
          Future.delayed(Duration(seconds: 1)).then((value) {
            if (widget.isNewUser)
              Get.to(() => UserInfoGetterScreen());
            else
              Get.off(() => HomeScreen());
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
                isNewUser: widget.isNewUser,
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
        // Called when Verification failed
        // 1. Invalid Phone
        // 2. Sms Quota Finished
        this.changeButtonToErrorState();
        print('Error Verfication Failed: ${error.message}');
        if (error.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
    );
  }
}

//                      TODO:  Current Page Tasks      ✘  or ✔
//
// TODO:        Task Name                                              Status
// TODO:        Validate Phone Number                                     ✔
// TODO:        Tell User you are not registered                          ✘
// TODO:        Tell user you are already been registered                 ✘
// TODO:        Make Style Consistent                                     ✘
// TODO:        Keep Single Source of Truth                               ✘
