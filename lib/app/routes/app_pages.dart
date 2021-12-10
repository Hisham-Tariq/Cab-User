import 'package:driving_app_its/app/ui/layouts/app/home_layout.dart';

import '../bindings/location_access_binding.dart';
import '../ui/pages/location_access_page/location_access_page.dart';
import '../bindings/bindings.dart';
import '../ui/pages/trip_feedback_page/trip_feedback_page.dart';
import '../ui/pages/contact_page/contact_page.dart';
import '../ui/pages/new_trip_booking_page/new_trip_booking_page.dart';
import '../ui/pages/user_info_page/user_info_page.dart';
import '../ui/pages/otp_page/otp_page.dart';
import '../ui/pages/phone_input_page/phone_input_page.dart';
import '../ui/pages/introduction_page/introduction_page.dart';
import '../ui/pages/splash_page/splash_page.dart';
import 'package:get/get.dart';
import '../ui/pages/unknown_route_page/unknown_route_page.dart';
import 'app_routes.dart';

const _defaultTransition = Transition.native;

class AppPages {
  static final unknownRoutePage = GetPage(
    name: AppRoutes.UNKNOWN,
    page: () => const UnknownRoutePage(),
    transition: _defaultTransition,
  );

  static final List<GetPage> pages = [
    unknownRoutePage,
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomeLayout(),
      binding: HomeBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashPage(),
      binding: SplashBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.INTRODUCTION,
      page: () => const IntroductionPage(),
      binding: IntroductionBinding(),
      transition: _defaultTransition,
    ),
    // GetPage(
    //   name: AppRoutes.PHONE_INPUT,
    //   page: () => const PhoneInputPage(),
    //   binding: PhoneInputBinding(),
    //   transition: _defaultTransition,
    // ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const PhoneInputPage(),
      binding: PhoneInputBinding(isNewUser: false),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.SIGNUP,
      page: () => const PhoneInputPage(),
      binding: PhoneInputBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.OTP,
      page: () => const OtpPage(),
      binding: OtpBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.USER_INFO,
      page: () => const UserInfoPage(),
      binding: UserInfoBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.NEW_TRIP_BOOKING,
      page: () => NewTripBookingPage(),
      binding: NewTripBookingBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.CONTACT,
      page: () => const ContactPage(),
      binding: ContactBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppRoutes.TRIP_FEEDBACK,
      page: () => const TripFeedbackPage(),
      binding: TripFeedbackBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.LOCATION_ACCESS,
      page: () => const LocationAccessPage(),
      binding: LocationAccessBinding(),
      transition: _defaultTransition,
    ),
  ];
}
