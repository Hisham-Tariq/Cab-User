import 'package:driving_app_its/app/controllers/controllers.dart';
import 'package:driving_app_its/app/ui/global_widgets/global_widgets.dart';
import 'package:driving_app_its/app/ui/pages/new_trip_booking_page/widgets/widgets.dart';

import '../../../generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/text_theme.dart';
import '../../../utils/utils.dart';

enum VehicleType { rickshaw, bike, car }
// At What stage of Chosing Vehicle is
// 1. Main Type such as Rikshaw, Car, or Bike --> VehicleType
//          or
// 2. Some Specific Vehicle such as in Bikes it could be Seventy --> SpecificVehicle

// ignore: must_be_immutable
class ChoseVehicle extends StatelessWidget {
  ChoseVehicle({Key? key, required this.onBack, required this.onVehicleSelected}) : super(key: key);
  final Function onVehicleSelected;
  final Callback onBack;

  VehicleType? currentVehicleType;

  final vehicleTypesValues = <VehicleType, String>{
    VehicleType.bike: 'Bike',
    VehicleType.car: 'Car',
    VehicleType.rickshaw: 'Rickshaw',
  };

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  // height: 350,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20.0),
                    ),
                  ),
                  child: GetBuilder<NewTripBookingController>(
                    init: NewTripBookingController(),
                    initState: (_) {},
                    builder: (logic) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                'Chose Vehicle',
                                style: AppTextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: context.theme.colorScheme.primary,
                                  fontSize: ResponsiveSize.height(9),
                                ),
                              ),
                            ),
                          ),
                          const VerticalSpacer(space: 4),
                          _showInfo('Distance', logic.tripDirections!.totalDistance, context),
                          _showInfo('Expected Time', logic.tripDirections!.totalDuration, context),
                          const VerticalSpacer(space: 6),
                          vehicleTypeWidget(),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  RichText _showInfo(title, value, BuildContext context) {
    return RichText(
      text: TextSpan(
        text: '',
        children: [
          TextSpan(
            text: '$title: ',
            style: AppTextStyle(
              color: context.theme.colorScheme.primary,
              fontSize: ResponsiveSize.height(7),
              fontWeight: FontWeight.w900,
            ),
          ),
          TextSpan(
            text: value,
            style: AppTextStyle(
              color: context.theme.colorScheme.onSurface,
              fontSize: ResponsiveSize.height(6),
            ),
          ),
        ],
      ),
    );
  }

  calculatePrice(key) {
    var controller = Get.find<NewTripBookingController>();
    var vehiclePrices = controller.prices![key];
    var surgeBoost = controller.prices!['surgeBoost'];
    return ((vehiclePrices['baseFare'] +
            ((vehiclePrices['costPerMin'] * controller.tripDurationInMins) + (vehiclePrices['costPerKm'] * controller.tripDistance)) * surgeBoost +
            vehiclePrices['bookingFee']) as double)
        .toInt();
  }

  vehicleTypeWidget() {
    return Column(
      children: [
        VehicleTile(
          title: 'Rikshaws',
          desc: 'New Rikshaws with comfortable seats',
          onTap: () {
            currentVehicleType = VehicleType.rickshaw;
            onVehicleSelected(
              vehicleTypesValues[currentVehicleType],
              calculatePrice('rickshaw'),
            );
          },
          vehicleSvgPath: Assets.svgRickshaw,
          price: calculatePrice('rickshaw'),
        ),
        const VerticalSpacer(space: 3),
        VehicleTile(
          title: 'Bike',
          desc: 'Affordable rides, All to yourself',
          onTap: () {
            currentVehicleType = VehicleType.bike;
            onVehicleSelected(
              vehicleTypesValues[currentVehicleType],
              calculatePrice('bike'),
            );
          },
          vehicleSvgPath: Assets.svgBike,
          price: calculatePrice('bike'),
        ),
        const VerticalSpacer(space: 3),
        VehicleTile(
          title: 'Car',
          desc: 'Safe and comfortable rides',
          onTap: () {
            currentVehicleType = VehicleType.car;
            onVehicleSelected(
              vehicleTypesValues[currentVehicleType],
              calculatePrice('car'),
            );
          },
          vehicleSvgPath: Assets.svgCar,
          price: calculatePrice('car'),
        ),
      ],
    );
  }
}

class VehicleTile extends StatelessWidget {
  const VehicleTile({
    Key? key,
    required this.title,
    required this.desc,
    required this.onTap,
    required this.vehicleSvgPath,
    required this.price,
  }) : super(key: key);

  final String title;
  final String desc;
  final Callback onTap;
  final String vehicleSvgPath;
  final int price;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        boxShadow: [
          BoxShadow(
            offset: Offset.zero,
            blurRadius: 2.0,
            blurStyle: BlurStyle.inner,
            spreadRadius: 0.5,
            color: context.theme.colorScheme.inverseSurface,
          ),
        ],
      ),
      child: Material(
        child: ListTile(
          // contentPadding: EdgeInsets.zero,
          minVerticalPadding: 24.0,
          tileColor: context.theme.colorScheme.surfaceVariant,
          leading: Container(
            height: double.infinity,
            width: 60.0,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: SvgPicture.asset(
              vehicleSvgPath,
              height: 20,
            ),
          ),
          trailing: Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Text(
              'Rs. $price',
              style: AppTextStyle(
                color: context.theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          title: Text(
            title,
            style: AppTextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.normal,
              color: context.theme.colorScheme.onSurfaceVariant,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
