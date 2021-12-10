import 'package:driving_app_its/app/controllers/controllers.dart';
import 'package:get/get.dart';

class DependecyInjection {
  static void init() {
    // Get.put<NavigationController>(NavigationController());
    // Get.put<MainController>(MainController());
    Get.put<UserController>(
      UserController(),
      permanent: true,
    );
  }
}