
import 'package:get/get.dart';
import '../controllers/user_info_controller.dart';


class UserInfoBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserInfoController>(() => UserInfoController());
        // Get.put<UserInfoController>(UserInfoController());
  }
}