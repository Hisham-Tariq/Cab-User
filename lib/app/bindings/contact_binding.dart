
import 'package:get/get.dart';
import '../controllers/contact_controller.dart';


class ContactBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactController>(() => ContactController());
        // Get.put<ContactController>(ContactController());
  }
}