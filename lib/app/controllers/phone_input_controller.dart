import 'package:driving_app_its/app/controllers/user_controller.dart';
import 'package:driving_app_its/app/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:progress_state_button/progress_button.dart';

class PhoneInputController extends GetxController {
  PhoneInputController({this.isNewUser = true}) {
    isNewUser.printInfo();
  }
  final bool isNewUser;
  final _userController = Get.find<UserController>();
  final formKey = GlobalKey<FormState>();

  final phoneController = TextEditingController();
  final phoneFocusNode = FocusNode();

  final buttonState = ButtonState.idle.obs;

  changeToErrorState() async {
    buttonState.value = ButtonState.fail;
    await Future.delayed(const Duration(seconds: 2));
    changeToIdleState();
  }

  changeToLoadingState() => buttonState.value = ButtonState.loading;
  changeToIdleState() => buttonState.value = ButtonState.idle;
  changeToSuccessState() => buttonState.value = ButtonState.success;

  String get formatedPhoneNumber {
    return '+92${phoneController.text.replaceFirst("0", "")}';
  }

  Future<bool> checkUserExistenceInFirebase() async {
    var phoneNumber = formatedPhoneNumber;
    var isExist = await _userController.userWithPhoneNumberIsExist(phoneNumber);
    if (isNewUser && isExist) {
      Fluttertoast.showToast(msg: "Rider already exist, Try to Login");
      changeToErrorState();
      return false;
    } else if (!isNewUser && !isExist) {
      Fluttertoast.showToast(msg: "Rider doesn't exist, please get yourself register");
      changeToErrorState();
      return false;
    }
    return true;
  }

  onSuccessfullyAuth() {
    if (isNewUser) {
      Get.offAllNamed(AppRoutes.USER_INFO);
    } else {
      var controller = Get.find<UserController>();
      controller.readCurrentUser().then((_) => Get.offAllNamed(AppRoutes.NEW_TRIP_BOOKING));
    }
  }

  Future<void> verifyPhoneNumber() async {
    phoneFocusNode.unfocus();
    if (!formKey.currentState!.validate()) return;
    changeToLoadingState();
    var isExist = await _userController.userWithPhoneNumberIsExist(formatedPhoneNumber);
    if (isNewUser && isExist) {
      Fluttertoast.showToast(msg: 'User already exist, Try to login');
      changeToErrorState();
      return;
    } else if (!isNewUser && !isExist) {
      Fluttertoast.showToast(msg: 'User doesn\'t exist, Please get yourself register');
      changeToErrorState();
      return;
      // User try to login without first registering the phone number
    }

    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
      phoneNumber: formatedPhoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // TODO:
        await auth.signInWithCredential(credential);
        changeToSuccessState();
      },
      codeSent: (String verificationId, int? forceResendingToken) {
        changeToSuccessState();
        Future.delayed(const Duration(seconds: 1)).then((value) {
          var arguments = <String, dynamic>{
            "isNewUser": isNewUser,
            "verificationId": verificationId,
            "forceResendingToken": forceResendingToken,
          };
          Get.toNamed(AppRoutes.OTP, arguments: arguments);
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      verificationFailed: (FirebaseAuthException error) {
        changeToErrorState();
      },
    );
  }

  String? validatePhoneNumber(String? value) {
    if (value!.isEmpty) {
      return 'Must provide the phone number';
    } else if (value.length != 11) {
      return 'Invalid Phone Number';
    }
    return null;
  }
}
