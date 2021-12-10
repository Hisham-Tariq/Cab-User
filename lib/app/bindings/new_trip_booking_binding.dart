import 'package:get/get.dart';
import '../controllers/new_trip_booking_controller.dart';

class NewTripBookingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewTripBookingController>(() => NewTripBookingController(), fenix: true);
    // Get.put<NewTripBookingController>(NewTripBookingController());
  }
}
