import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import '../controller/controller.dart';

class AppBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<UserController>(
      UserController(),
      permanent: true,
    );
  }
}
