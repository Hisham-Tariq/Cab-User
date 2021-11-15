
import 'package:get/get.dart';
import '../controllers/introduction_controller.dart';


class IntroductionBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IntroductionController>(() => IntroductionController());
        // Get.put<IntroductionController>(IntroductionController());
  }
}