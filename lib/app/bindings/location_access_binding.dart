
import 'package:get/get.dart';
import '../controllers/location_access_controller.dart';


class LocationAccessBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationAccessController>(() => LocationAccessController());
        // Get.put<LocationAccessController>(LocationAccessController());
  }
}