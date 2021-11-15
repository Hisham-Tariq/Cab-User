
import 'package:get/get.dart';
import '../controllers/trip_feedback_controller.dart';


class TripFeedbackBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TripFeedbackController>(() => TripFeedbackController());
        // Get.put<TripFeedbackController>(TripFeedbackController());
  }
}