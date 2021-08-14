import 'package:driving_app_its/customization/customization.dart';
import 'package:driving_app_its/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class TripAtIdleState extends StatelessWidget {
  const TripAtIdleState({Key? key, required this.onSchedule}) : super(key: key);
  final Callback onSchedule;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      height: 200,
      child: Container(
        padding: EdgeInsets.all(12.0),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //TODO: Task Position
            Text(
              'Good Afternoon Test',
              style: AppTextStyle.heading1,
            ),
            VerticalAppSpacer(),
            GestureDetector(
              onTap: onSchedule,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                height: 60,
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
                      padding: EdgeInsets.all(10.0),
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
