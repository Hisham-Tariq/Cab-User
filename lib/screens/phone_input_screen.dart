import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import '../controller/controller.dart';
import '../customization/customization.dart';
import '../widgets/widgets.dart';
import '../routes/paths.dart';

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

  ButtonState buttonState = ButtonState.idle;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userController = Get.find<UserController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                        'Phone Number',
                        style: GoogleFonts.catamaran(
                          color: Colors.black45,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextFormField(
                        focusNode: phoneFocusNode,
                        controller: phoneController,
                        decoration: const InputDecoration(),
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
                      // PhoneFormFieldHint(
                      //   focusNode: phoneFocusNode,
                      //   controller: phoneController,
                      //   decoration: InputDecoration(),
                      //   // child: TextField(),
                      //   validator: (value) {
                      //     if (value!.isEmpty) {
                      //       return 'Must provide the phone number';
                      //     } else if (value.contains('+92') &&
                      //         (value.length < 13 || value.length > 14)) {
                      //       return 'Invalid Phone Number';
                      //     } else if (!value.contains('+92') &&
                      //         (value.length < 10 || value.length > 11)) {
                      //       return 'Invalid Phone Number';
                      //     }
                      //     return null;
                      //   },
                      // ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: ProgressButton.icon(
                              iconedButtons: const {
                                ButtonState.idle: IconedButton(
                                  text: "Continue",
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
                              onPressed: verifyPhoneNumber,
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

  changeButtonToErrorState() {
    setState(() {
      buttonState = ButtonState.fail;
      Future.delayed(const Duration(seconds: 2)).then((value) {
        setState(() {
          buttonState = ButtonState.idle;
        });
      });
    });
  }

  // Check if the number is provided with +92 if not it will add +92 at start
  String get formattedPhoneNumber => phoneController.text.contains("+92")
      ? phoneController.text
      : '+92${phoneController.text}';

  Future<void> verifyPhoneNumber() async {
    phoneFocusNode.unfocus();
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      buttonState = ButtonState.loading;
    });
    var phoneNumber = formattedPhoneNumber;
    var isExist = await _userController.userWithPhoneNumberIsExist(phoneNumber);
    if (widget.isNewUser && isExist) {
      // User try to register when the phone number already been registered
      print('User With this Phone Number is Already Exist try to Login');
      changeButtonToErrorState();
      return;
    } else if (!widget.isNewUser && !isExist) {
      print(
          'User With this Phone Number does not exist, try to register first');
      changeButtonToErrorState();
      return;
      // User try to login without first registering the phone number
    }

    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Automatic handling of the SMS code on Android devices.
        await auth.signInWithCredential(credential);

        setState(() {
          buttonState = ButtonState.success;
          Future.delayed(const Duration(seconds: 1)).then((value) {
            if (widget.isNewUser) {
              Get.toNamed(AppPaths.userInfo);
            } else {
              Get.offAllNamed(AppPaths.tripBooking);
            }
          });
        });
      },
      codeSent: (String verificationId, int? forceResendingToken) {
        // Called when Code has been sended
        setState(() {
          buttonState = ButtonState.success;
          Future.delayed(const Duration(seconds: 1)).then((value) {
            var arguments = <String, dynamic>{
              "isNewUser": widget.isNewUser,
              "verificationId": verificationId,
              "forceResendingToken": forceResendingToken,
            };
            print(arguments);
            Get.toNamed(AppPaths.otp, arguments: arguments);
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
        changeButtonToErrorState();
        print('Error Verfication Failed: ${error.message}');
        if (error.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
    );
  }
}
