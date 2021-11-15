import 'package:driving_app_its/app/models/models.dart';
import 'package:driving_app_its/app/routes/app_routes.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:progress_state_button/progress_button.dart';
import 'user_controller.dart';

class UserInfoController extends GetxController {
  final UserController _userController = Get.find<UserController>();
  final formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final firstNameNode = FocusNode();

  final lastNameController = TextEditingController();
  final lastNameNode = FocusNode();

  final emailController = TextEditingController();
  final emailNode = FocusNode();

  final buttonState = ButtonState.idle.obs;

  changeToErrorState() async {
    buttonState.value = ButtonState.fail;
    await Future.delayed(const Duration(seconds: 2));
    changeToIdleState();
  }

  changeToLoadingState() => buttonState.value = ButtonState.loading;
  changeToIdleState() => buttonState.value = ButtonState.idle;
  changeToSuccessState() => buttonState.value = ButtonState.success;

  Future<void> handleAddUserData() async {
    // Remove Focus From Fields on Tap
    FocusScope.of(Get.context!).unfocus();
    // Validate The Form
    if (!formKey.currentState!.validate()) return;
    // Set Button State = Loading
    changeToLoadingState();
    // Add Users Data to User's DataModel
    final _user = UserModel(
      email: emailController.text,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      phoneNumber: _userController.currentUserPhoneNumber,
    );
    _userController.user = _user;
    // Add the User Personal Info in the Firestore
    if (await _userController.createUser()) {
      // After Successfully Added the User's Data
      changeToSuccessState();
      Future.delayed(const Duration(seconds: 1)).then((value) {
        //  Navigate to Home Screen
        Get.offAllNamed(AppRoutes.NEW_TRIP_BOOKING);
      });
    } else {
      // Error While adding the User's Data
      changeToErrorState();
    }
  }
}
