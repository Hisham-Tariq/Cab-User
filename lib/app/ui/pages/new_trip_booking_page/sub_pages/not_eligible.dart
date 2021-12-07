import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../global_widgets/spacers.dart';
import 'package:get/get.dart';

class NotEligibleForBooking extends StatelessWidget {
  const NotEligibleForBooking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(30.0),
            ),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, -3),
                color: Colors.grey.shade400,
                blurRadius: 15.0,
                spreadRadius: 2.0,
              ),
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Not Eligible',
                style: GoogleFonts.catamaran(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const VerticalSpacer(space: 16.0),
            const Text("You can not book a new trip until you complete your previous."),
            const VerticalSpacer(space: 16.0),
            // TODO: Add Click Action Functionality
            TextButton(
              onPressed: () {},
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
