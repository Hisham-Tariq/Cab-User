import 'package:get/get.dart';
import '../controllers/phone_input_controller.dart';

class PhoneInputBinding implements Bindings {
  PhoneInputBinding({this.isNewUser = true});
  final bool isNewUser;
  @override
  void dependencies() {
    Get.lazyPut<PhoneInputController>(() => PhoneInputController(isNewUser: isNewUser));
    // Get.put<PhoneInputController>(PhoneInputController());
  }
}
