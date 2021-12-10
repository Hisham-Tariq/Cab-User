import 'package:driving_app_its/app/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:progress_state_button/progress_button.dart';

import 'user_controller.dart';

class OtpController extends GetxController {
  String get verificationId => Get.arguments['verificationId'];
  int? get forceResendingToken => Get.arguments['forceResendingToken'];
  bool get isNewUser => Get.arguments['isNewUser'];
  final otpFieldNode = FocusNode();
  String otpCode = '';
  final buttonState = ButtonState.idle.obs;

  changeToErrorState() async {
    buttonState.value = ButtonState.fail;
    await Future.delayed(const Duration(seconds: 2));
    changeToIdleState();
  }

  changeToLoadingState() => buttonState.value = ButtonState.loading;
  changeToIdleState() => buttonState.value = ButtonState.idle;
  changeToSuccessState() => buttonState.value = ButtonState.success;

  void onOtpChanged(String value) {
    otpCode = value;

    if (value.length == 6) {
      FocusScope.of(Get.context!).unfocus();
      otpFieldNode.unfocus();
      Future.delayed(const Duration(milliseconds: 10)).then((value) {
        verifyOTPCode();
      });
    }
  }

  _onSuccessfullyAuth() async {
    changeToSuccessState();
    await Future.delayed(const Duration(seconds: 1));
    if (isNewUser) {
      Get.offAllNamed(AppRoutes.USER_INFO);
    } else {
      var controller = Get.find<UserController>();
      controller.readCurrentUser().then((_) => Get.offAllNamed(AppRoutes.HOME));
    }
  }

  Future<void> verifyOTPCode() async {
    changeToLoadingState();
    FirebaseAuth auth = FirebaseAuth.instance;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otpCode,
    );
    try {
      await auth.signInWithCredential(credential);
      _onSuccessfullyAuth();
    } catch (e) {
      if (FirebaseAuth.instance.currentUser != null) {
        _onSuccessfullyAuth();
      } else {
        changeToErrorState();
      }
    }
  }
}
