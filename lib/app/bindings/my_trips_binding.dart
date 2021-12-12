
import 'package:get/get.dart';
import '../controllers/my_trips_controller.dart';


class MyTripsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyTripsController>(() => MyTripsController());
        // Get.put<MyTripsController>(MyTripsController());
  }
}