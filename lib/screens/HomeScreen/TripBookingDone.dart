import 'package:driving_app_its/customization/customization.dart';
import 'package:driving_app_its/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

import 'widgets.dart';

class BookingDone extends StatelessWidget {
  const BookingDone({Key? key, required this.tripInfo, required this.onBack})
      : super(key: key);
  final Map<String, String> tripInfo;
  final Callback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              padding: EdgeInsets.all(12.0),
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
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
                    child:
                        Text('Trip Detail', style: AppTextStyle.primaryHeading),
                  ),
                  VerticalAppSpacer(space: 16),
                  Row(
                    children: [
                      Text('Pickup: ', style: AppTextStyle.emphasisTitle),
                      HorizontalAppSpacer(),
                      Text(tripInfo['pickup'] as String,
                          style: AppTextStyle.normal),
                    ],
                  ),
                  VerticalAppSpacer(),
                  Row(
                    children: [
                      Text('Destination: ', style: AppTextStyle.emphasisTitle),
                      HorizontalAppSpacer(),
                      Expanded(
                        child: Container(
                          child: SingleChildScrollView(
                            child: Text(tripInfo['destination'] as String,
                                style: AppTextStyle.normal),
                          ),
                        ),
                      ),
                    ],
                  ),
                  VerticalAppSpacer(),
                  Row(
                    children: [
                      Text('Distance: ', style: AppTextStyle.emphasisTitle),
                      HorizontalAppSpacer(),
                      Text(tripInfo['distance'] as String,
                          style: AppTextStyle.normal),
                    ],
                  ),
                  VerticalAppSpacer(),
                  Row(
                    children: [
                      Text('Duration: ', style: AppTextStyle.emphasisTitle),
                      HorizontalAppSpacer(),
                      Text(tripInfo['duration'] as String,
                          style: AppTextStyle.normal),
                    ],
                  ),
                  Expanded(child: Container()),
                  FullTextButton(onPressed: () {}, text: 'Book Now')
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
