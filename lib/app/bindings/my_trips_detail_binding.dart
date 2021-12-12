
import 'package:get/get.dart';
import '../controllers/my_trips_detail_controller.dart';


class MyTripsDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyTripsDetailController>(() => MyTripsDetailController());
        // Get.put<MyTripsDetailController>(MyTripsDetailController());
  }
}