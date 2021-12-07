import 'package:driving_app_its/app/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'user_controller.dart';

class SplashController extends GetxController {
  @override
  onInit() async {
    super.onInit();
    (await isLocationPermissionGranted()).printInfo();
    if (await isLocationPermissionGranted()) {
      var controller = Get.find<UserController>();
      if (controller.isUserNotLoggedIn) {
        Future.delayed(const Duration(seconds: 1)).then((_) => Get.offAllNamed(AppRoutes.INTRODUCTION));
      } else {
        // User is Signed In
        controller.userWithPhoneNumberIsExist(controller.userPhoneNumber).then((value) {
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
    } else {
      Get.offAllNamed(AppRoutes.LOCATION_ACCESS);
    }
  }

  Future<bool> isLocationPermissionGranted() async {
    return Permission.locationWhenInUse.status.isGranted;
  }
}
