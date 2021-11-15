
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../routes/app_routes.dart';
import 'user_controller.dart';
class LocationAccessController extends GetxController {

  Future<bool> requestLocaionPermission() async {
    if (!(await Permission.locationWhenInUse.request().isGranted)) {
      Get.snackbar(
        'Location',
        'Location permission must be granted in order to use the app',
      );
      return false;
    }
    return true;
  }
  
  handleGrantAcess() async {
    if(await requestLocaionPermission()){
      var controller = Get.find<UserController>();
      if (controller.isUserNotLoggedIn) {
        Future.delayed(const Duration(seconds: 1))
            .then((_) => Get.offAllNamed(AppRoutes.INTRODUCTION));
      } else {
        // User is Signed In
        controller
            .userWithPhoneNumberIsExist(controller.userPhoneNumber)
            .then((value) {
          if (value) {
            controller.readCurrentUser().then((_) {
              Get.offAllNamed(AppRoutes.NEW_TRIP_BOOKING);
            });
          } else {
            //  Rider didn't provide his Details
            controller.user.phoneNumber = controller.userPhoneNumber;
            controller.user.id = controller.currentUserUID;
            Get.offAllNamed(AppRoutes.USER_INFO);
          }
        });
      }
    }
  }
}