import 'package:driving_app_its/app/controllers/controllers.dart';
import 'package:driving_app_its/app/ui/global_widgets/global_widgets.dart';
import 'package:driving_app_its/app/ui/pages/new_trip_booking_page/widgets/widgets.dart';

import '../../../customization/customization.dart';
import '../../../generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:google_fonts/google_fonts.dart';


enum VehicleType { rickshaw, bike, car }
// At What stage of Chosing Vehicle is
// 1. Main Type such as Rikshaw, Car, or Bike --> VehicleType
//          or
// 2. Some Specific Vehicle such as in Bikes it could be Seventy --> SpecificVehicle

// ignore: must_be_immutable
class ChoseVehicle extends StatelessWidget {
  ChoseVehicle(
      {Key? key, required this.onBack, required this.onVehicleSelected})
      : super(key: key);
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
                  padding: const EdgeInsets.all(12.0),
                  height: 350,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0)),
                  ),
                  child: GetBuilder<NewTripBookingController>(
                    init: NewTripBookingController(),
                    initState: (_) {},
                    builder: (logic) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _showInfo(
                              'Distance', logic.tripDirections!.totalDistance),
                          _showInfo('Expected Time',
                              logic.tripDirections!.totalDuration),
                          Text(
                            'Chose Vehicle',
                            style: AppTextStyle.primaryHeading.copyWith(
                              color: Colors.black,
                            ),
                          ),
                          const VerticalSpacer(space: 16),
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

  RichText _showInfo(title, value) {
    return RichText(
      text: TextSpan(
        text: '',
        children: [
          TextSpan(
            text: '$title: ',
            style: GoogleFonts.catamaran(
              color: Colors.green,
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: value,
            style: GoogleFonts.catamaran(
              color: Colors.black,
              fontSize: 16.0,
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
            ((vehiclePrices['costPerMin'] * controller.tripDurationInMins) +
                    (vehiclePrices['costPerKm'] * controller.tripDistance)) *
                surgeBoost +
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
        const VerticalSpacer(),
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
        const VerticalSpacer(),
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
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Material(
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          tileColor: Colors.grey.shade100,
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
            child: Text('Rs. $price'),
          ),
          title: Text(title),
          onTap: onTap,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
