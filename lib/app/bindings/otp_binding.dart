
import 'package:get/get.dart';
import '../controllers/otp_controller.dart';


class OtpBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpController>(() => OtpController());
        // Get.put<OtpController>(OtpController());
  }
}