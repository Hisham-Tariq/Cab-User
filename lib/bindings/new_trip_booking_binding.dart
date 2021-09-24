import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import '../controller/controller.dart';

class NewTripBookingBindings implements Bindings {
  @override
  void dependencies() {
    // Get.put<NewTripBookingController>(NewTripBookingController());
    Get.lazyPut(() => NewTripBookingController());
  }
}
