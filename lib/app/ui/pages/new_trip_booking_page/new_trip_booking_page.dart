import '../../../controllers/controllers.dart';
import 'sub_pages/not_eligible.dart';
import '../../utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'sub_pages/sub_pages.dart';
import 'widgets/widgets.dart';
import 'package:flutter/services.dart';

class NewTripBookingPage extends GetView<NewTripBookingController> {
  NewTripBookingPage({Key? key}) : super(key: key);
  final _userController = Get.find<UserController>();

  changeMapStyle(BuildContext context) async {
    if (context.theme.brightness == Brightness.dark) {
      var style = await rootBundle.loadString("assets/mapStyles/dark.json");
      try {
        controller.googleMapController!.setMapStyle(style);
      } catch (e) {
        "Error in Dark Mode".printInfo();
      }
    } else {
      try {
        controller.googleMapController!.setMapStyle(null);
      } catch (e) {
        "Error in Normal Mode".printInfo();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (controller.googleMapController != null) {
      try {
        changeMapStyle(context);
      } on MissingPluginException {
        "No Plusing ".printInfo();
      }
    }
    return Material(
      child: GetBuilder<NewTripBookingController>(
        dispose: (state) {
          controller.googleMapController = null;
          controller.resetBookingState();
        },
        initState: (state) {
        },
        builder: (logic) {
          if (logic.currentCameraLatLng == null) {
            return Center(
              child: SpinKitCircle(
                color: context.theme.colorScheme.primary,
              ),
            );
          } else {
            return SafeArea(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Google Map
                  GoogleMap(
                    zoomControlsEnabled: false,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    initialCameraPosition: logic.initialCameraPosition as CameraPosition,
                    onMapCreated: (controller) {
                      logic.googleMapController = controller;
                      changeMapStyle(context);
                    },
                    markers: {
                      if (logic.pickup != null) logic.pickup!.marker,
                      if (logic.destination != null) logic.destination!.marker,
                      if (controller.availableRidersLocation.isNotEmpty) ...controller.availableRidersLocation.values.toSet(),
                    },
                    polylines: {
                      if (logic.tripDirections != null)
                        Polyline(
                          polylineId: const PolylineId('overview_polyline'),
                          color: context.theme.colorScheme.primary,
                          width: 5,
                          points: logic.tripDirections!.polylinePoints.map((e) => LatLng(e.latitude, e.longitude)).toList(),
                        ),
                    },
                    onCameraMove: (position) {
                      if (logic.tripBookingStep == 1 || logic.tripBookingStep == 2) {
                        controller.currentCameraPosDebouncer.run(() {
                          logic.currentCameraLatLng = LatLng(
                            position.target.latitude,
                            position.target.longitude,
                          );
                        });
                      }
                    },
                  ),
                  // Middle Circle
                  const Positioned(child: MiddleScreenLocationIcon()),
                  // Bottom Container

                  /////////      Trip Start Widget       ////////
                  if (logic.tripBookingStep == 0 && _userController.user.eligible!)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: TripAtIdleState(onSchedule: logic.forwardBookingState),
                    ),
                  /////////      Not Eligible Widget       ////////
                  if (logic.tripBookingStep == 0 && !_userController.user.eligible!)
                    const Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: NotEligibleForBooking(),
                    ),
                  /////////      Pickup Location Widget       ////////
                  AnimatedPositioned(
                    top: logic.tripBookingStep == 1 ? 0 : Get.height,
                    child: SetLocation(
                      title: 'Pickup',
                      intialAddress: controller.pickup != null ? controller.pickup!.address ?? "" : "",
                      onContinue: () {
                        if (logic.isPickupLocationIsValid) {
                          logic.forwardBookingState();
                        } else {
                          showAppSnackBar(
                            'Pickup Location',
                            'Please chose a valid pickup location',
                          );
                        }
                      },
                      onLocationSelectedByPlace: logic.pickupLocationSelectedByPlace,
                      onLocationSelectedByMap: logic.pickupLocationByMap,
                    ),
                    duration: const Duration(milliseconds: 300),
                  ),
                  /////////      Destination Location Widget       ////////
                  AnimatedPositioned(
                    top: logic.tripBookingStep == 2 ? 0 : Get.height,
                    child: SetLocation(
                      title: 'Destination',
                      intialAddress: controller.destination != null ? controller.destination!.address ?? "" : "",
                      onContinue: () {
                        if (logic.isDestinationLocationIsValid) {
                          logic.forwardBookingState();
                        } else {
                          showAppSnackBar(
                            'Destination Location',
                            'Please chose a valid destination location',
                          );
                        }
                      },
                      onLocationSelectedByPlace: logic.destinationLocationSelectedByPlace,
                      onLocationSelectedByMap: logic.destinationLocationByMap,
                    ),
                    duration: const Duration(milliseconds: 300),
                  ),
                  if (logic.tripBookingStep == 3)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ChoseVehicle(
                        onVehicleSelected: (String vehicle, int price) {
                          logic.selectedVehicle = vehicle;
                          logic.totalPrice = price;
                          logic.forwardBookingState;
                          logic.findNearbyRiders();
                        },
                      ),
                    ),
                  if (logic.tripBookingStep == 5)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: BookingDone(
                        tripInfo: {
                          'distance': logic.tripDirections!.totalDistance,
                          'duration': logic.tripDirections!.totalDuration,
                          'destination': logic.destination!.address!,
                          'pickup': logic.pickup!.address!,
                        },
                      ),
                    ),
                  /////////      Booking State Change Widget       ////////
                  Positioned(
                    top: 10,
                    left: 10,
                    child: logic.tripBookingStep == 0 ? const HomeDrawerTogggleButton() : HomeBackButton(onTap: controller.backwardBookingState),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class HomeDrawerTogggleButton extends StatelessWidget {
  const HomeDrawerTogggleButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 25.0,
      backgroundColor: context.theme.colorScheme.primary,
      child: IconButton(
        icon: Icon(
          Icons.menu,
          color: context.theme.colorScheme.onPrimary,
          size: 20.0,
        ),
        onPressed: () {
          Get.find<NavigationController>().scaffoldState.currentState!.openDrawer();
        },
      ),
    );
  }
}
