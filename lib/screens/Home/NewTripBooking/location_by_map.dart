import 'package:driving_app_its/customization/customization.dart';
import 'package:driving_app_its/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'widgets.dart';

class LocationByMap extends StatelessWidget {
  final pickupController = TextEditingController();
  final destinationController = TextEditingController();

  final pickupFocus = FocusNode();
  final destFocus = FocusNode();

  final String pickupAddress;
  final LatLng pickupLocation;
  final String? destinationAddress;
  final LatLng? destinationLocation;
  final Callback onDestinationSelected;
  final Callback onPickupSelected;
  final Callback onContinue;
  final Callback onBack;
  final Callback onConfirmLocation;

  LocationByMap({
    Key? key,
    required this.onBack,
    required this.pickupAddress,
    required this.pickupLocation,
    this.destinationAddress,
    this.destinationLocation,
    required this.onDestinationSelected,
    required this.onPickupSelected,
    required this.onContinue,
    required this.onConfirmLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    destinationController.text = destinationAddress ?? '';
    pickupController.text = pickupAddress;
    return Container(
      // color: Colors.white,
      height: double.infinity,
      width: double.infinity,
      padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
      child: Stack(
        children: [
          Positioned(
            // left: 0,
            // top: 0,
            child: HomeBackButton(onTap: onBack),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.all(8.0),
              height: 120,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _addressTextFields(
                      controller: pickupController,
                      hint: 'Pickup',
                      onTap: () {
                        pickupFocus.unfocus();
                        onPickupSelected();
                      },
                      focus: pickupFocus),
                  VerticalAppSpacer(),
                  _addressTextFields(
                    controller: destinationController,
                    hint: 'Destination',
                    onTap: () {
                      destFocus.unfocus();
                      onDestinationSelected();
                    },
                    focus: destFocus,
                  ),
                ],
              ),
            ),
          ),
          Align(
            // left: 10,
            // bottom: 10,
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    AppTextButton(
                      onPressed: onConfirmLocation,
                      text: 'Confirm Location',
                    ),
                    AppTextOutlinedButton(
                      onPressed: onContinue,
                      text: 'Continue',
                    ),
                  ],
                ),
                VerticalAppSpacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextField _addressTextFields({
    required TextEditingController controller,
    required String hint,
    required Callback onTap,
    required FocusNode focus,
  }) {
    return TextField(
      controller: controller,
      focusNode: focus,
      style: AppTextStyle.textField,
      decoration: InputDecoration(
        hintText: hint,
        labelText: hint,
      ),
      onTap: onTap,
    );
  }
}
