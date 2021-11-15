import 'package:driving_app_its/app/controllers/controllers.dart';
import 'package:driving_app_its/app/ui/customization/customization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'booking_state.dart';
import 'sub_pages/sub_pages.dart';
import 'widgets/widgets.dart';
import '../../global_widgets/global_widgets.dart';

class NewTripBookingPage extends GetView<NewTripBookingController> {
  const NewTripBookingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaf,
      drawer: const AppDrawer(),
      extendBodyBehindAppBar: true,
      body: GetBuilder<NewTripBookingController>(builder: (logic) {
        if (logic.currentLatLng == null) {
          return const Center(
            child: SpinKitCircle(
              color: AppColors.primary,
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
                  onMapCreated: (controller) =>
                      logic.googleMapController = controller,
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
                        color: Colors.red,
                        width: 5,
                        points: logic.tripDirections!.polylinePoints
                            .map((e) => LatLng(e.latitude, e.longitude))
                            .toList(),
                      ),
                  },
                  onCameraMove: (position) {
                    if (logic.currentBookingState == BookingState.pickup ||
                        logic.currentBookingState == BookingState.destination) {
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

                if (logic.currentBookingState == BookingState.idle)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: CircleAvatar(
                      radius: 20.0,
                      backgroundColor: Colors.green,
                      child: IconButton(
                        icon: const Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 15.0,
                        ),
                        onPressed: () {
                          controller.scaf.currentState!.openDrawer();
                        },
                      ),
                    ),
                  ),
                if (logic.currentBookingState == BookingState.idle)
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
                        Get.snackbar(
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
                        Get.snackbar(
                          'Pickup Location',
                          'Please chose a valid pickup location',
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
      }),
    );
  }
}
