import 'package:driving_app_its/customization/customization.dart';
import 'package:driving_app_its/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

import 'widgets.dart';

enum VehicleTypes { rikshaw, bike, car }
// At What stage of Chosing Vehicle is
// 1. Main Type such as Rikshaw, Car, or Bike --> VehicleType
//          or
// 2. Some Specific Vehicle such as in Bikes it could be Seventy --> SpecificVehicle
enum ChoseVehicleState { vehicleType, specificVehicle }

class ChoseVehicle extends StatefulWidget {
  const ChoseVehicle(
      {Key? key, required this.onBack, required this.onVehicleSelected})
      : super(key: key);
  final Function onVehicleSelected;
  final Callback onBack;

  @override
  _ChoseVehicleState createState() => _ChoseVehicleState();
}

class _ChoseVehicleState extends State<ChoseVehicle> {
  ChoseVehicleState vehicleState = ChoseVehicleState.vehicleType;
  VehicleTypes? currentVehicleType;

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
            child: HomeBackButton(onTap: widget.onBack),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(12.0),
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (vehicleState == ChoseVehicleState.specificVehicle)
                            GestureDetector(
                              child: Icon(
                                Icons.arrow_back,
                                color: AppColors.primary,
                              ),
                              onTap: () => this.setState(() {
                                this.vehicleState =
                                    ChoseVehicleState.vehicleType;
                              }),
                            ),
                          Expanded(
                            child: Center(
                              child: Text('Chose Vehicle',
                                  style: AppTextStyle.primaryHeading),
                            ),
                          ),
                        ],
                      ),
                      VerticalAppSpacer(space: 16),
                      if (vehicleState == ChoseVehicleState.vehicleType)
                        vehicleTypeWidget(),
                      if (vehicleState == ChoseVehicleState.specificVehicle &&
                          (currentVehicleType == VehicleTypes.bike))
                        onChoseBike(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  onChoseBike() {
    return Column(
      children: [
        choseVehicleTile(
          title: 'Yamaha YBR',
          onTap: widget.onVehicleSelected,
          price: 180,
          vehicleSvg: "assets/svg/bike.svg",
        ),
        VerticalAppSpacer(),
        choseVehicleTile(
          title: 'Honda Seventy',
          onTap: widget.onVehicleSelected,
          price: 120,
          vehicleSvg: "assets/svg/bike.svg",
        ),
      ],
    );
  }

  vehicleTypeWidget() {
    return Column(
      children: [
        choseVehicleTypeTile(
            title: 'Rikshaws',
            description: 'New Rikshaws with comfortable seats',
            onTap: () {
              print('sdhjsd');
              this.setState(() {
                this.vehicleState = ChoseVehicleState.specificVehicle;
                currentVehicleType = VehicleTypes.rikshaw;
              });
            },
            vehicleSvg: "assets/svg/rickshaw.svg"),
        VerticalAppSpacer(),
        choseVehicleTypeTile(
          title: 'Bike',
          description: 'Affordable rides, All to yourself',
          onTap: () {
            this.setState(() {
              this.vehicleState = ChoseVehicleState.specificVehicle;
              currentVehicleType = VehicleTypes.bike;
            });
          },
          vehicleSvg: "assets/svg/bike.svg",
        ),
      ],
    );
  }

  choseVehicleTile({title, onTap, price, vehicleSvg}) {
    return InkWell(
      key: UniqueKey(),
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.hardEdge,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.fromBorderSide(
            BorderSide(
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: double.infinity,
              padding: EdgeInsets.all(12.0),
              child: SvgPicture.asset(vehicleSvg, height: 32),
            ),
            VerticalDivider(width: 0.0),
            HorizontalAppSpacer(space: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.emphasisText,
                  ),
                ],
              ),
            ),
            Container(
              width: 80,
              height: double.infinity,
              child: Center(
                child: Text(
                  'Rs.$price',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  choseVehicleTypeTile({title, description, onTap, vehicleSvg}) {
    return InkWell(
      key: UniqueKey(),
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.hardEdge,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.fromBorderSide(
            BorderSide(
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: double.infinity,
              padding: EdgeInsets.all(12.0),
              // color: Colors.grey.shade400,
              child: SvgPicture.asset(
                vehicleSvg,
              ),
            ),
            VerticalDivider(width: 0.0),
            HorizontalAppSpacer(space: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: AppTextStyle.emphasisText),
                  Text(description, style: AppTextStyle.description),
                ],
              ),
            ),
            Container(
              width: 40,
              height: double.infinity,
              child: Icon(
                Icons.arrow_right,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
