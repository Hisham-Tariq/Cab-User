import 'package:driving_app_its/app/controllers/navigation_controller.dart';
import 'package:flutter/material.dart';

import '../../../global_widgets/spacers.dart';
import 'package:get/get.dart';

class NotEligibleForBooking extends StatelessWidget {
  const NotEligibleForBooking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 0),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            color: context.theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(30.0),
            ),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, -3),
                color: context.theme.colorScheme.onInverseSurface,
                blurRadius: 230.0,
                spreadRadius: 1.0,
              ),
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Not Eligible',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const VerticalSpacer(space: 16.0),
            const Text("You can not book a new trip until you complete your previous."),
            const VerticalSpacer(space: 16.0),
            TextButton(
              onPressed: Get.find<NavigationController>().moveToMyTrips,
              child: const Text("Go to My Trips"),
              style: TextButton.styleFrom(
                fixedSize: Size(Get.width, 50),
              ),
            ),
            const VerticalSpacer(space: 8.0),
          ],
        ),
      ),
    );
  }
}
