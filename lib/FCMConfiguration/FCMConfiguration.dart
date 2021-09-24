import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driving_app_its/controller/controller.dart';
import 'package:driving_app_its/generated/assets.dart';
import 'package:driving_app_its/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:material_dialogs/material_dialogs.dart';
// import 'package:material_dialogs/widgets/buttons/icon_button.dart';
// import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

Future<void> clearNotifications() async {
  try {
    const platform = MethodChannel('notifications');
    final result = await platform.invokeMethod('clearAppNotifications');
    print(result);
    print('Message Cleared');
  } on PlatformException catch (e) {
    print("Failed to clear notifications: '${e.message}'.");
  }
}

Future<void> firebaseBackgroundMessageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
  // await clearNotifications();
}

void handleResponseReceivedAboutNewTripFromRider(RemoteMessage message) {}

void handleConfirmUserTripHasStarted(RemoteMessage message) {
  Dialogs.materialDialog(
      barrierDismissible: false,
      msg: message.notification!.body,
      title: "Ride Started?",
      color: Colors.white,
      lottieBuilder: Lottie.asset(
        Assets.animCar,
        fit: BoxFit.contain,
      ),
      context: Get.context as BuildContext,
      actions: [
        FullTextButton(
          onPressed: () {
            print(
                'Booking Id: ${Get.find<UserController>().user.currentBooking}');
            FirebaseFirestore.instance
                .collection('BookedTrips')
                .doc(Get.find<UserController>().user.currentBooking)
                .collection('response')
                .doc('start')
                .update({'response': true});
            // updateTheRiderResponse(true, message.data['tripId']);
            navigator!.pop();
          },
          text: 'Yes',
        ),
        FullOutlinedTextButton(
          onPressed: () {
            FirebaseFirestore.instance
                .collection('BookedTrips')
                .doc(Get.find<UserController>().user.currentBooking)
                .collection('response')
                .doc('start')
                .update({'response': false});
            // updateTheRiderResponse(true, message.data['tripId']);
            navigator!.pop();
          },
          text: 'No',
          buttonColor: Colors.red,
        )
      ]);
}

void handleConfirmUserTripHasEnded(RemoteMessage message) {
  Dialogs.materialDialog(
      barrierDismissible: false,
      msg: message.notification!.body,
      title: "Ride Ended?",
      color: Colors.white,
      lottieBuilder: Lottie.asset(
        Assets.animCar,
        fit: BoxFit.contain,
      ),
      context: Get.context as BuildContext,
      actions: [
        FullTextButton(
          onPressed: () async {
            await FirebaseFirestore.instance
                .collection('BookedTrips')
                .doc(Get.find<UserController>().user.currentBooking)
                .collection('response')
                .doc('end')
                .update({'response': true});
            Get.snackbar('Ride', 'Ride successfully completed');
            // updateTheRiderResponse(true, message.data['tripId']);
            navigator!.pop();
            Get.toNamed('/rideFeedBack');
          },
          text: 'Yes',
        ),
        FullOutlinedTextButton(
          onPressed: () {
            FirebaseFirestore.instance
                .collection('BookedTrips')
                .doc(Get.find<UserController>().user.currentBooking)
                .collection('response')
                .doc('end')
                .update({'response': false});
            // updateTheRiderResponse(true, message.data['tripId']);
            navigator!.pop();
          },
          text: 'No',
          buttonColor: Colors.red,
        )
      ]);
}

firebaseForegroundMessage(RemoteMessage message) {
  print(message.notification!.body);
  Get.snackbar('Notification', message.notification!.body as String);
  if (message.data.containsKey('funName') &&
      FirebaseAuth.instance.currentUser != null) {
    switch (message.data['funName']) {
      case 'notifyTheUserAboutHisTripRiderResponse':
        handleResponseReceivedAboutNewTripFromRider(message);
        break;
      case 'confirmUserTripHasStarted':
        handleConfirmUserTripHasStarted(message);
        break;
      case 'confirmUserTripHasEnded':
        handleConfirmUserTripHasEnded(message);
        break;
    }
  }
}

firebaseOnMessageClicked(RemoteMessage message) {
  print(message.notification!.title);
  if (message.data.containsKey('funName') &&
      FirebaseAuth.instance.currentUser != null) {
    print(message.notification!.title);
    switch (message.data['funName']) {
      case 'notifyTheUserAboutHisTripRiderResponse':
        handleResponseReceivedAboutNewTripFromRider(message);
        break;
      case 'confirmUserTripHasStarted':
        handleConfirmUserTripHasStarted(message);
        break;
      case 'confirmUserTripHasEnded':
        handleConfirmUserTripHasEnded(message);
        break;
    }
  }
}
