import 'package:driving_app_its/app/controllers/controllers.dart';
import 'package:driving_app_its/app/data/models/booked_trip_model/booked_trip_model.dart';
import 'package:driving_app_its/app/routes/app_routes.dart';
import 'package:driving_app_its/app/ui/global_widgets/spacers.dart';
import 'package:driving_app_its/app/ui/theme/text_theme.dart';
import 'package:driving_app_its/app/ui/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controllers/my_trips_controller.dart';

// Color Indicators
// Ended: Primary
// Started: Teritry
// Pending: Amber
// Canceld: Error

class MyTripsPage extends GetView<MyTripsController> {
  const MyTripsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GetBuilder<MyTripsController>(
        builder: (_) {
          if (controller.trips.isEmpty) {
            return const _HaveNoTrips();
          }
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      child: Card(
                        // height: 80,
                        // width: Get.width,
                        child: SizedBox(
                          height: ResponsiveSize.height(90),
                          width: Get.width,
                          child: Stack(
                            children: [
                              _MyTripCard(trip: controller.trips[index]),
                              _TripIndicator(index: index, status: controller.trips[index].tripStatus)
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Container(
                      height: 0,
                      width: Get.width,
                      color: context.theme.colorScheme.error,
                      child: Text(index.toString()),
                    );
                  },
                  itemCount: controller.trips.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TripIndicator extends StatelessWidget {
  const _TripIndicator({
    Key? key,
    required this.index,
    required this.status,
  }) : super(key: key);
  final int index;
  final String status;

  getIndicatorColor(String status, BuildContext context) {
    switch (status) {
      case 'pending':
        return Colors.amber;
      case 'started':
        return context.theme.colorScheme.tertiary;
      case 'ended':
        return context.theme.colorScheme.primary;
      case 'canceld':
        return context.theme.colorScheme.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -35,
      right: -35,
      child: Container(
        height: 80,
        width: 80,
        padding: const EdgeInsets.all(22),
        child: Text(
          (index + 1).toString(),
          style: AppTextStyle(
            color: context.theme.colorScheme.onTertiary,
            fontWeight: FontWeight.bold,
          ),
        ),
        alignment: Alignment.bottomLeft,
        decoration: BoxDecoration(
          color: getIndicatorColor(status, context),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.elliptical(50, 100),
          ),
        ),
      ),
    );
  }
}

class _MyTripCard extends StatelessWidget {
  const _MyTripCard({Key? key, required this.trip}) : super(key: key);

  final BookedTripModel trip;

  Row _labeldInfo(String title, String value, BuildContext context) {
    return Row(
      children: [
        Text(
          title + ": ",
          style: AppTextStyle(
            fontWeight: FontWeight.bold,
            color: context.theme.colorScheme.secondary,
            fontSize: ResponsiveSize.height(6.5),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyle(
              fontSize: ResponsiveSize.height(5),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                width: Get.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _labeldInfo("Pickup", trip.pickupAddress, context),
                    const VerticalSpacer(space: 4),
                    _labeldInfo("Destination", trip.destinationAddress, context),
                    const VerticalSpacer(space: 4),
                    _labeldInfo("Booked At: ", DateFormat.yMd().add_jm().format(DateTime.parse(trip.bookedAt)), context),
                  ],
                ),
              ),
            ),
            OutlinedButton(
              child: const Text("More"),
              onPressed: () {
                
                Get.toNamed(AppRoutes.MY_TRIPS_DETAIL, arguments: trip);
              },
            )
          ],
        ),
      ),
    );
  }
}

class _HaveNoTrips extends StatelessWidget {
  const _HaveNoTrips({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.exposure_zero,
            size: ResponsiveSize.height(80),
            color: context.theme.colorScheme.secondary,
          ),
          const VerticalSpacer(space: 4),
          Text(
            "You Don't Have any Trips",
            style: AppTextStyle(
              fontSize: ResponsiveSize.height(10),
              color: context.theme.colorScheme.secondary,
              fontWeight: FontWeight.w900,
            ),
          ),
          const VerticalSpacer(space: 6),
          TextButton(
            onPressed: Get.find<NavigationController>().moveToBookATrip,
            child: const Text("Go to Booking"),
          ),
        ],
      ),
    );
  }
}
