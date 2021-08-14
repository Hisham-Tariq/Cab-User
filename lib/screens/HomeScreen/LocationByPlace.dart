import 'package:driving_app_its/controller/controller.dart';
import 'package:driving_app_its/customization/customization.dart';
import 'package:driving_app_its/models/models.dart';
import 'package:driving_app_its/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:timelines/timelines.dart';

import 'widgets.dart';

class LocationByPlace extends StatefulWidget {
  final String pickupAddress;
  final LatLng pickupLocation;
  final String? destinationAddress;
  final LatLng? destinationLocation;
  final Callback onBack;
  final void Function(Place) onDestinationSelected;
  final void Function(Place) onPickupSelected;
  final Callback onContinue;
  final Callback onLocationByMap;

  const LocationByPlace({
    Key? key,
    required this.onBack,
    required this.onDestinationSelected,
    required this.onPickupSelected,
    this.pickupAddress = '',
    required this.pickupLocation,
    required this.onLocationByMap,
    required this.onContinue,
    this.destinationAddress,
    this.destinationLocation,
  }) : super(key: key);

  @override
  _LocationByPlaceState createState() => _LocationByPlaceState();
}

class _LocationByPlaceState extends State<LocationByPlace> {
  bool isDestinationSelected = false;
  final pickupController = TextEditingController();
  final destinationController = TextEditingController();
  final searchPlaceDebouncer = Debouncer(miliseconds: 300);
  List<Place> places = [];

  @override
  void initState() {
    super.initState();
    this.pickupController.text = widget.pickupAddress;
    this.destinationController.text = widget.destinationAddress ?? '';
  }

  _LocationByPlaceState() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
      color: Colors.white,
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        children: [
          Column(
            children: [
              // VerticalAppSpacer(space: 24.0),
              Row(
                children: [
                  HorizontalAppSpacer(space: 50),
                  CurrentTimeField(),
                ],
              ),
              VerticalAppSpacer(),
              Row(
                children: [
                  Container(
                    width: 50,
                    child: Column(
                      children: [
                        DotIndicator(color: AppColors.primary),
                        // !isDestinationSelected
                        //     ? DotIndicator(color: AppColors.primary)
                        //     : OutlinedDotIndicator(color: AppColors.primary),
                        SizedBox(
                          height: 60.0,
                          child: isDestinationSelected
                              ? SolidLineConnector(color: AppColors.primary)
                              : DashedLineConnector(color: AppColors.primary),
                        ),
                        isDestinationSelected
                            ? DotIndicator(color: AppColors.primary)
                            : OutlinedDotIndicator(color: AppColors.primary),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        _addressTextFields(
                          controller: pickupController,
                          hint: 'From?',
                          onTap: _onFocusOnPickup,
                          onTapOnMap: () {
                            widget.onLocationByMap();
                          },
                        ),
                        VerticalAppSpacer(),
                        _addressTextFields(
                          controller: destinationController,
                          hint: 'Where to?',
                          onTap: _onFocusOnDestination,
                          onTapOnMap: () {
                            widget.onLocationByMap();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              VerticalAppSpacer(space: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: places.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: Column(
                        children: [
                          ListTile(
                            onTap: () => _onLocationSelected(index),
                            leading: Container(
                              height: 25,
                              width: 25,
                              child: Icon(
                                Icons.place,
                                color: Colors.white,
                                size: 15.0,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            title: Text(
                              places[index].name,
                              style: AppTextStyle.title,
                            ),
                            horizontalTitleGap: 1.0,
                            subtitle: Text(
                              places[index].address,
                              style: AppTextStyle.subtitle,
                            ),
                          ),
                          Divider(height: 0.5),
                        ],
                      ),
                    );
                  },
                ),
              ),
              VerticalAppSpacer(),
              FullTextButton(onPressed: widget.onContinue, text: 'Continue'),
              VerticalAppSpacer(),
            ],
          ),
          Positioned(
            // left: 0,
            // top: 0,
            child: HomeBackButton(onTap: widget.onBack),
          ),
        ],
      ),
    );
  }

  TextField _addressTextFields({
    required TextEditingController controller,
    required String hint,
    required Callback onTapOnMap,
    required Callback onTap,
  }) {
    return TextField(
      controller: controller,
      style: AppTextStyle.textField,
      decoration: InputDecoration(
        suffixIcon: GestureDetector(
          onTap: onTapOnMap,
          child: Icon(
            Icons.map,
            color: AppColors.primary,
          ),
        ),
        hintText: hint,
      ),
      onTap: onTap,
      onChanged: (value) {
        searchPlaceDebouncer.run(() {
          var placeController = PlaceController();
          placeController
              .getNearbyPlaces(
            userLocation: widget.pickupLocation,
            keyword: value,
          )
              .then((value) {
            this.setState(() {
              this.places = value;
            });
          });
        });
      },
    );
  }

  _onFocusOnPickup() {
    if (this.isDestinationSelected)
      this.setState(() {
        this.isDestinationSelected = false;
      });
  }

  _onFocusOnDestination() {
    if (!this.isDestinationSelected)
      this.setState(() {
        this.isDestinationSelected = true;
      });
  }

  _onLocationSelected(int index) {
    if (this.isDestinationSelected) {
      destinationController.text = places[index].name;
      widget.onDestinationSelected(places[index]);
    } else {
      pickupController.text = places[index].name;
      widget.onPickupSelected(places[index]);
    }
  }
}
