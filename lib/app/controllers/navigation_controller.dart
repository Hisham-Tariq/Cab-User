import 'package:driving_app_its/app/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/drawer_navigation_item.dart';
import '../ui/pages/new_trip_booking_page/new_trip_booking_page.dart';
import '../ui/pages/contact_page/contact_page.dart';

class NavigationController extends GetxController {

  final scaffoldState = GlobalKey<ScaffoldState>();


  final List<DrawerNavigationItem> drawerNavigationItems = [
    // New Trip
    DrawerNavigationItem(
      "New Trip",
      Icons.car_repair,
      () {
        // Get.toNamed(AppRoutes.NEW_TRIP_BOOKING);
      },
      NewTripBookingPage(),
      isSelected: true,
      showAppBar: false,
    ),
    // Contact Us
    DrawerNavigationItem("Contact Us", Icons.mail, () {
      // Get.toNamed(AppRoutes.CONTACT);
    }, const ContactPage()),
    // Sign Out
    DrawerNavigationItem(
      "Sign Out",
      Icons.exit_to_app,
      () async {
        FirebaseAuth.instance.signOut();
        Get.offAll(AppRoutes.INTRODUCTION);
      },
      const SizedBox(),
    ),
  ];

  late final Rx<DrawerNavigationItem> selectedDrawerItem;

  @override
  onInit() {
    super.onInit();
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
}
