import 'package:driving_app_its/app/ui/global_widgets/spacers.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/my_trips_detail_controller.dart';
import '../../theme/text_theme.dart';
import '../../utils/utils.dart';

class MyTripsDetailPage extends GetView<MyTripsDetailController> {
  const MyTripsDetailPage({Key? key}) : super(key: key);

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
    SystemChrome.setSystemUIOverlayStyle(
      context.theme.brightness == Brightness.dark
          ? SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: context.theme.colorScheme.primary,
              systemNavigationBarColor: context.theme.colorScheme.surface,
            )
          : SystemUiOverlayStyle.light.copyWith(
              statusBarColor: context.theme.colorScheme.primary,
              systemNavigationBarColor: context.theme.colorScheme.surface,
            ),
    );
    return SafeArea(
      child: Scaffold(
        body: GetBuilder<MyTripsDetailController>(
          builder: (_) {
            if (controller.trip == null) {
              return Center(
                child: SpinKitCircle(
                  color: context.theme.colorScheme.primary,
                ),
              );
            }
            return Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: Container(
                    width: Get.width,
                    padding: const EdgeInsets.fromLTRB(12.0, 0, 12, 0),
                    height: ResponsiveSize.height(90),
                    color: context.theme.colorScheme.surfaceVariant,
                    child: Column(
                      children: [
                        const VerticalSpacer(),
                        Center(
                          child: Text(
                            "Trip Detail",
                            style: AppTextStyle(
                              fontSize: ResponsiveSize.height(12),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const VerticalSpacer(),
                        _labeldInfo("Pickup", controller.trip!.pickupAddress, context),
                        const VerticalSpacer(space: 2),
                        _labeldInfo("Destination", controller.trip!.destinationAddress, context),
                        const VerticalSpacer(space: 2),
                        _labeldInfo(
                          "Booked At",
                          DateFormat.yMd().add_jm().format(DateTime.parse(controller.trip!.bookedAt)),
                          context,
                        ),
                        const VerticalSpacer(space: 2),
                        _labeldInfo(
                          "Completed At",
                          controller.trip!.completedAt != null
                              ? DateFormat.yMd().add_jm().format(DateTime.parse(controller.trip!.completedAt!))
                              : "Not Yet",
                          context,
                        ),
                        const VerticalSpacer(space: 2),
                        _labeldInfo("Rider Name", controller.trip!.riderName, context),
                        const VerticalSpacer(space: 2),
                        _labeldInfo("Trip Cost", "Rs. " + controller.trip!.tripPrice.toString(), context),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: ResponsiveSize.height(90),
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: GoogleMap(
                    onMapCreated: (mapController) {
                      controller.googleMapController = mapController;
                      changeMapStyle(context);
                    },
                    initialCameraPosition: CameraPosition(
                      target: controller.trip!.userPickupLocation,
                      zoom: 11.5,
                    ),
                    markers: <Marker>{
                      Marker(
                        markerId: const MarkerId("Pickup"),
                        position: controller.trip!.userPickupLocation,
                        infoWindow: const InfoWindow(title: "Pickup Location"),
                        // TODO: Set Proper Marker Colors
                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
                      ),
                      Marker(
                        markerId: const MarkerId("Destination"),
                        position: controller.trip!.userDestinationLocation,
                        infoWindow: const InfoWindow(title: "Destination Location"),
                        // TODO: Set Proper Marker Colors
                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
                      ),
                    },
                    polylines: {
                      if (controller.tripDirections != null)
                        Polyline(
                          polylineId: const PolylineId('TripDirection'),
                          color: context.theme.colorScheme.primary,
                          width: 5,
                          points: controller.tripDirections!.polylinePoints.map((e) => LatLng(e.latitude, e.longitude)).toList(),
                        ),
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Row _labeldInfo(String title, String value, BuildContext context) {
    return Row(
      children: [
        Text(
          title + ": ",
          style: AppTextStyle(
            fontWeight: FontWeight.bold,
            color: context.theme.colorScheme.secondary,
            fontSize: ResponsiveSize.height(5),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyle(
              fontSize: ResponsiveSize.height(4.5),
            ),
          ),
        ),
      ],
    );
  }
}
