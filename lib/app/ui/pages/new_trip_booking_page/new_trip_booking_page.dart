import 'package:driving_app_its/app/controllers/controllers.dart';
import 'package:driving_app_its/app/ui/pages/new_trip_booking_page/sub_pages/not_eligible.dart';
import 'package:driving_app_its/app/ui/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'booking_state.dart';
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
        },
        builder: (logic) {
          if (logic.currentLatLng == null) {
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
                    initialCameraPosition:
                        logic.initialCameraPosition as CameraPosition,
                    onMapCreated: (controller) {
                      logic.googleMapController = controller;
                      changeMapStyle(context);
                    },
                    markers: {
                      logic.markers['pickup'] as Marker,
                      if (logic.markers['destination'] != null)
                        logic.markers['destination'] as Marker,
                      if (controller.availableRidersLocation.isNotEmpty)
                        ...controller.availableRidersLocation.values.toSet(),
                    },
                    polylines: {
                      if (logic.tripDirections != null)
                        Polyline(
                          polylineId: const PolylineId('overview_polyline'),
                          color: context.theme.colorScheme.primary,
                          width: 5,
                          points: logic.tripDirections!.polylinePoints
                              .map((e) => LatLng(e.latitude, e.longitude))
                              .toList(),
                        ),
                    },
                    onCameraMove: (position) {
                      if (logic.currentBookingState == BookingState.pickup ||
                          logic.currentBookingState ==
                              BookingState.destination) {
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

                  /////////      Drawer Open Widget       ////////
                  if (logic.currentBookingState == BookingState.idle)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: CircleAvatar(
                        radius: 25.0,
                        backgroundColor: context.theme.colorScheme.primary,
                        child: IconButton(
                          icon: Icon(
                            Icons.menu,
                            color: context.theme.colorScheme.onPrimary,
                            size: 20.0,
                          ),
                          onPressed: () {
                            Get.find<NavigationController>()
                                .scaffoldState
                                .currentState!
                                .openDrawer();
                          },
                        ),
                      ),
                    ),
                  /////////      Trip Start Widget       ////////
                  if (logic.currentBookingState == BookingState.idle &&
                      _userController.user.eligible!)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: TripAtIdleState(
                        onSchedule: () {
                          logic.changeBookingState(BookingState.pickup);
                        },
                      ),
                    ),
                  /////////      Not Eligible Widget       ////////
                  if (logic.currentBookingState == BookingState.idle &&
                      !_userController.user.eligible!)
                    const Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: NotEligibleForBooking(),
                    ),
                  /////////      Pickup Location Widget       ////////
                  AnimatedPositioned(
                    top: logic.currentBookingState == BookingState.pickup
                        ? 0
                        : Get.height,
                    child: SetLocation(
                      title: 'Pickup',
                      intialAddress: controller.pickupAddress!,
                      onBack: () {
                        logic.changeBookingState(BookingState.idle);
                      },
                      onContinue: () {
                        if (logic.isPickupLocationIsValid()) {
                          logic.changeBookingState(BookingState.destination);
                        } else {
                          showAppSnackBar(
                            'Pickup Location',
                            'Please chose a valid pickup location',
                          );
                        }
                      },
                      onLocationSelectedByPlace:
                          logic.pickupLocationSelectedByPlace,
                      onLocationSelectedByMap: logic.pickupLocationByMap,
                    ),
                    duration: const Duration(milliseconds: 300),
                  ),
                  /////////      Destination Location Widget       ////////
                  AnimatedPositioned(
                    top: logic.currentBookingState == BookingState.destination
                        ? 0
                        : Get.height,
                    child: SetLocation(
                      onBack: () {
                        logic.changeBookingState(BookingState.pickup);
                      },
                      title: 'Destination',
                      onContinue: () {
                        if (logic.isDestinationLocationIsValid()) {
                          logic.changeBookingState(BookingState.vehicle);
                        } else {
                          showAppSnackBar(
                            'Destination Location',
                            'Please chose a valid destination location',
                          );
                        }
                      },
                      onLocationSelectedByPlace:
                          logic.destinationLocationSelectedByPlace,
                      onLocationSelectedByMap: logic.destinationLocationByMap,
                    ),
                    duration: const Duration(milliseconds: 300),
                  ),
                  if (logic.currentBookingState == BookingState.vehicle)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ChoseVehicle(
                        onBack: () {
                          logic.changeBookingState(BookingState.destination);
                        },
                        onVehicleSelected: (String vehicle, int price) {
                          logic.selectedVehicle = vehicle;
                          logic.totalPrice = price;
                          logic.changeBookingState(BookingState.rider);
                          logic.findNearbyRiders();
                        },
                      ),
                    ),
                  if (logic.currentBookingState == BookingState.rider)
                    Positioned(
                      left: 8,
                      top: 8,
                      child: HomeBackButton(
                        onTap: () {
                          logic.changeBookingState(BookingState.vehicle);
                        },
                      ),
                    ),
                  if (logic.currentBookingState == BookingState.done)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: BookingDone(
                        onBack: () {
                          logic.changeBookingState(BookingState.rider);
                        },
                        tripInfo: {
                          'distance': logic.tripDirections!.totalDistance,
                          'duration': logic.tripDirections!.totalDuration,
                          'destination': logic.destinationAddress as String,
                          'pickup': logic.pickupAddress as String,
                        },
                      ),
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
