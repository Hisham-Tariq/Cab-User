import 'package:driving_app_its/app/controllers/contact_controller.dart';
import 'package:driving_app_its/app/controllers/navigation_controller.dart';
import 'package:driving_app_its/app/controllers/new_trip_booking_controller.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<NewTripBookingController>(() => NewTripBookingController(), fenix: true);
    Get.lazyPut<ContactController>(() => ContactController());
    Get.lazyPut<NavigationController>(() => NavigationController());
    // Get.put<HomeController>(HomeController());
  }
}
