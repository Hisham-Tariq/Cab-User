import 'package:driving_app_its/controller/controller.dart';
import 'package:driving_app_its/customization/customization.dart';
import 'package:driving_app_its/generated/assets.dart';
import 'package:driving_app_its/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:google_fonts/google_fonts.dart';

import 'widgets.dart';

enum VehicleType { rickshaw, bike, car }
// At What stage of Chosing Vehicle is
// 1. Main Type such as Rikshaw, Car, or Bike --> VehicleType
//          or
// 2. Some Specific Vehicle such as in Bikes it could be Seventy --> SpecificVehicle

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
                          const VerticalAppSpacer(space: 16),
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

  vehicleTypeWidget() {
    return Column(
      children: [
        VehicleTile(
          title: 'Rikshaws',
          desc: 'New Rikshaws with comfortable seats',
          onTap: () {
            currentVehicleType = VehicleType.rickshaw;
            onVehicleSelected(vehicleTypesValues[currentVehicleType]);
          },
          vehicleSvgPath: Assets.svgRickshaw,
        ),
        const VerticalAppSpacer(),
        VehicleTile(
          title: 'Bike',
          desc: 'Affordable rides, All to yourself',
          onTap: () {
            currentVehicleType = VehicleType.bike;
            onVehicleSelected(vehicleTypesValues[currentVehicleType]);
          },
          vehicleSvgPath: Assets.svgBike,
        ),
        const VerticalAppSpacer(),
        VehicleTile(
          title: 'Car',
          desc: 'Safe and comfortable rides',
          onTap: () {
            currentVehicleType = VehicleType.car;
            onVehicleSelected(vehicleTypesValues[currentVehicleType]);
          },
          vehicleSvgPath: Assets.svgCar,
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
  }) : super(key: key);

  final String title;
  final String desc;
  final Callback onTap;
  final String vehicleSvgPath;

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
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: SvgPicture.asset(
              vehicleSvgPath,
              height: 20,
            ),
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
