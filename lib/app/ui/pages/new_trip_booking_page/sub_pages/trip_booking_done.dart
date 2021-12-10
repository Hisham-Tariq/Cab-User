import 'package:driving_app_its/app/ui/global_widgets/global_widgets.dart';
import 'package:driving_app_its/app/ui/pages/new_trip_booking_page/widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class BookingDone extends StatelessWidget {
  const BookingDone({Key? key, required this.tripInfo, required this.onBack}) : super(key: key);
  final Map<String, String> tripInfo;
  final Callback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            left: 8,
            top: 8,
            child: HomeBackButton(onTap: onBack),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(12.0),
              height: 300,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text('Trip Detail'),
                  ),
                  const VerticalSpacer(space: 16),
                  Row(
                    children: [
                      const Text('Pickup: '),
                      const HorizontalSpacer(),
                      Text(tripInfo['pickup'] as String),
                    ],
                  ),
                  const VerticalSpacer(),
                  Row(
                    children: [
                      const Text('Destination: '),
                      const HorizontalSpacer(),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(tripInfo['destination'] as String),
                        ),
                      ),
                    ],
                  ),
                  const VerticalSpacer(),
                  Row(
                    children: [
                      const Text('Distance: '),
                      const HorizontalSpacer(),
                      Text(tripInfo['distance'] as String),
                    ],
                  ),
                  const VerticalSpacer(),
                  Row(
                    children: [
                      const Text('Duration: '),
                      const HorizontalSpacer(),
                      Text(tripInfo['duration'] as String),
                    ],
                  ),
                  Expanded(child: Container()),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Book Now'),
                    style: TextButton.styleFrom(
                      minimumSize: Size(Get.width, 50)
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
