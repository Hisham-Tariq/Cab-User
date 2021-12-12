
import 'package:get/get.dart';
import '../controllers/help_us_controller.dart';


class HelpUsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HelpUsController>(() => HelpUsController());
        // Get.put<HelpUsController>(HelpUsController());
  }
}