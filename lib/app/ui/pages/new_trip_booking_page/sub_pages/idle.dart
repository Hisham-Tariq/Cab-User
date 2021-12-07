import 'package:driving_app_its/app/controllers/controllers.dart';
import 'package:driving_app_its/app/ui/customization/customization.dart';
import 'package:driving_app_its/app/ui/global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:google_fonts/google_fonts.dart';

class TripAtIdleState extends StatelessWidget {
  const TripAtIdleState({Key? key, required this.onSchedule}) : super(key: key);
  final Callback onSchedule;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
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
                'Start Trip',
                style: GoogleFonts.catamaran(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const VerticalSpacer(space: 16.0),
            Text(
              'Welcome ${GetUtils.capitalize(Get.find<UserController>().user.firstName as String)}',
              style: GoogleFonts.catamaran(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            const VerticalSpacer(space: 16.0),
            GestureDetector(
              onTap: onSchedule,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(
                    20.0,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Where to?',
                        style: AppTextStyle.heading1,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          15.0,
                        ),
                      ),
                      child: Center(
                        child: Text('Schedule', style: AppTextStyle.small),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
