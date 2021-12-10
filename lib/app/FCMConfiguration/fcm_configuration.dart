import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driving_app_its/app/controllers/controllers.dart';
import 'package:driving_app_its/app/routes/app_routes.dart';
import 'package:driving_app_its/app/ui/generated/assets.dart';
import 'package:driving_app_its/app/ui/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_dialogs/material_dialogs.dart';

Future<void> firebaseBackgroundMessageHandler(RemoteMessage message) async {}

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
        TextButton(
          onPressed: () {
            print('Booking Id: ${Get.find<UserController>().user.currentBooking}');
            FirebaseFirestore.instance
                .collection('BookedTrips')
                .doc(Get.find<UserController>().user.currentBooking)
                .collection('response')
                .doc('start')
                .update({'response': true});
            // updateTheRiderResponse(true, message.data['tripId']);
            navigator!.pop();
          },
          child: const Text('Yes'),
        ),
        OutlinedButton(
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
          child: const Text('No'),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Get.context!.theme.colorScheme.error),
            primary: Get.context!.theme.colorScheme.error,
            minimumSize: Size(Get.width, 50),
          ),
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
        TextButton(
          onPressed: () async {
            await FirebaseFirestore.instance
                .collection('BookedTrips')
                .doc(Get.find<UserController>().user.currentBooking)
                .collection('response')
                .doc('end')
                .update({'response': true});
            showAppSnackBar(
              'Ride',
              'Ride Successfully completed',
              null,
              Icons.add_task,
            );
            // updateTheRiderResponse(true, message.data['tripId']);
            navigator!.pop();
            Get.toNamed(AppRoutes.TRIP_FEEDBACK);
          },
          child: Text('Yes'),
        ),
        OutlinedButton(
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
          child: const Text('No'),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Get.context!.theme.colorScheme.error),
            primary: Get.context!.theme.colorScheme.error,
            minimumSize: Size(Get.width, 50),
          ),
        )
      ]);
}

firebaseForegroundMessage(RemoteMessage message) {
  showAppSnackBar(
    'Notification',
    message.notification!.body as String,
    null,
    Icons.notifications_active,
  );
  if (message.data.containsKey('funName') && FirebaseAuth.instance.currentUser != null) {
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
  if (message.data.containsKey('funName') && FirebaseAuth.instance.currentUser != null) {
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
