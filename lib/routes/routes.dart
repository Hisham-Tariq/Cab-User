import '../bindings/bindings.dart';
import 'package:get/get.dart';
import '../screens/screens.dart';
import 'paths.dart';

const animDuration = Duration(seconds: 1);

var routes = [
  GetPage(
    name: AppPaths.initial,
    page: () => const SplashScreen(),
  ),
  GetPage(
    name: AppPaths.signupLogin,
    title: 'SignInSingUp',
    page: () => const IntroScreen(),
    transition: Transition.topLevel,
    transitionDuration: animDuration,
  ),
  GetPage(
    name: AppPaths.login,
    title: 'Login',
    page: () => const PhoneInputScreen(isNewUser: false),
    transition: Transition.topLevel,
    transitionDuration: animDuration,
  ),
  GetPage(
    name: AppPaths.signup,
    title: 'Signup',
    page: () => const PhoneInputScreen(),
    transition: Transition.topLevel,
    transitionDuration: animDuration,
  ),
  GetPage(
    name: AppPaths.otp,
    page: () => OTPScreen(),
    transition: Transition.topLevel,
    transitionDuration: animDuration,
  ),
  GetPage(
    name: AppPaths.userInfo,
    page: () => UserInfoGetterScreen(),
    transition: Transition.topLevel,
    transitionDuration: animDuration,
  ),
  // GetPage(
  //   name: AppPaths.tripBooking,
  //   page: () => const HomeScreen(),
  //   transition: Transition.topLevel,
  //   transitionDuration: animDuration,
  // ),
  GetPage(
    name: AppPaths.tripBooking,
    page: () => const NewTripBookingScreen(),
    transition: Transition.topLevel,
    transitionDuration: animDuration,
    binding: NewTripBookingBindings(),
  ),
  GetPage(
    name: AppPaths.tripFeedBack,
    page: () => RideFeedBackScreen(),
    transition: Transition.topLevel,
    transitionDuration: animDuration,
  ),
  GetPage(
    name: AppPaths.contact,
    page: () => const ContactScreen(),
    transition: Transition.topLevel,
    transitionDuration: animDuration,
  ),
];
