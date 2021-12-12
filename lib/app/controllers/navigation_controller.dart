import 'package:driving_app_its/app/routes/app_routes.dart';
import 'package:driving_app_its/app/ui/pages/help_us_page/help_us_page.dart';
import 'package:driving_app_its/app/ui/pages/my_trips_page/my_trips_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import '../models/drawer_navigation_item.dart';
import '../ui/pages/new_trip_booking_page/new_trip_booking_page.dart';
import '../ui/pages/contact_page/contact_page.dart';

class NavigationController extends GetxController {
  final scaffoldState = GlobalKey<ScaffoldState>();

  final List<DrawerNavigationItem> drawerNavigationItems = [
    DrawerNavigationItem(
      "My Trips",
      Icons.map_outlined,
      DrawerItemType.viewBased,
      widget: const MyTripsPage(),
    ),
    // New Trip
    DrawerNavigationItem(
      "New Trip",
      Icons.car_repair,
      DrawerItemType.viewBased,
      showAppBar: false,
      widget: NewTripBookingPage(),
    ),
    // Contact Us
    DrawerNavigationItem(
      "Contact Us",
      Icons.mail,
      DrawerItemType.viewBased,
      widget: const ContactPage(),
    ),
    DrawerNavigationItem(
      "Help Us",
      Icons.help,
      DrawerItemType.viewBased,
      widget: const HelpUsPage(),
    ),
    // Sign Out
    DrawerNavigationItem(
      "Rate Us",
      Icons.star,
      DrawerItemType.callAble,
      onTap: () async {
        final InAppReview inAppReview = InAppReview.instance;
        // inAppReview.openStoreListing(); // eMoves the user to playstor
        if (await inAppReview.isAvailable()) {
          inAppReview.requestReview();
        }
      },
    ),
    DrawerNavigationItem(
      "Sign Out",
      Icons.exit_to_app,
      DrawerItemType.callAble,
      onTap: () async {
        FirebaseAuth.instance.signOut();
        Get.offAllNamed(AppRoutes.INTRODUCTION);
      },
    ),
  ];

  late final Rx<DrawerNavigationItem> selectedDrawerItem;

  @override
  onInit() {
    super.onInit();
    drawerNavigationItems.first.isSelected = true;
    selectedDrawerItem = drawerNavigationItems.first.obs;
  }

  onDrawerItemClicked(DrawerNavigationItem item) {
    for (DrawerNavigationItem drawerItem in drawerNavigationItems) {
      drawerItem.isSelected = drawerItem.title == item.title;
      if (drawerItem.title == item.title) {
        selectedDrawerItem.value = drawerItem;
      }
    }
    update();
  }

  moveToMyTrips() {
    onDrawerItemClicked(drawerNavigationItems.first);
  }

  void moveToBookATrip() {
    onDrawerItemClicked(drawerNavigationItems.where((element) => element.title == "New Trip").first);
  }
}
