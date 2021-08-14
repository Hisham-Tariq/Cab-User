// import 'package:cab_rider_its/controller/controller.dart';
// import 'package:cab_rider_its/generated/assets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
// import 'package:material_dialogs/material_dialogs.dart';
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

firebaseForegroundMessage(RemoteMessage message) {
  if (message.data.containsKey('funName') &&
      FirebaseAuth.instance.currentUser != null) {
    switch (message.data['funName']) {
      case 'notifyTheUserAboutHisTripRiderResponse':
        handleResponseReceivedAboutNewTripFromRider(message);
        break;
      // case 'requestTheRiderAboutNewTrip':
      //   handleRequestTheRiderAboutNewTrip(message);
      //   break;
    }
  }
}

firebaseOnMessageClicked(message) {
  print('Message Clicked');
}
