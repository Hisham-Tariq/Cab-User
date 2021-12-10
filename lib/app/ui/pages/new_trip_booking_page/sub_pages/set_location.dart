import 'package:driving_app_its/app/controllers/controllers.dart';
import 'package:driving_app_its/app/ui/global_widgets/global_widgets.dart';

import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

import '../../../../models/models.dart';
import 'package:flutter/material.dart';

import '../../../theme/text_theme.dart';
import '../../../utils/utils.dart';

enum LocationBy { place, map }

class SetLocation extends StatefulWidget {
  const SetLocation({
    Key? key,
    required this.title,
    required this.onContinue,
    required this.onLocationSelectedByPlace,
    required this.onLocationSelectedByMap,
    this.intialAddress = "",
  }) : super(key: key);
  final String title;
  final Function onLocationSelectedByPlace;
  final Function onLocationSelectedByMap;
  final Callback onContinue;
  final String intialAddress;

  @override
  State<SetLocation> createState() => _SetLocationState();
}

class _SetLocationState extends State<SetLocation> {
  @override
  initState() {
    super.initState();
    widget.title.printInfo();
    widget.intialAddress.printInfo();
    _fieldController.text = widget.intialAddress;
  }

  List<Place> places = [];
  static const _animationDuration = Duration(milliseconds: 400);

  final _fieldController = TextEditingController();
  LocationBy _locationBy = LocationBy.place;
  final _searchPlaceBouncer = Debouncer(miliseconds: 300);

  final _fieldNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Stack(
          children: [
            AnimatedPositioned(
              bottom: _locationBy == LocationBy.map ? 0 : Get.width,
              child: _locationByMap(),
              duration: _animationDuration,
            ),
            AnimatedPositioned(
              top: _locationBy == LocationBy.place ? 0 : Get.height,
              duration: _animationDuration,
              child: _locationByPlace(),
            ),
            // Positioned(
            //   top: 10,
            //   left: 10,
            //   child: CircleAvatar(
            //     radius: 25.0,
            //     backgroundColor: context.theme.colorScheme.primary.withOpacity(0),
            //     child: IconButton(
            //       icon: Icon(Icons.arrow_back, color: context.theme.colorScheme.primary),
            //       onPressed: widget.onBack,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer _locationByPlace() {
    return AnimatedContainer(
      decoration: BoxDecoration(color: context.theme.colorScheme.surface),
      height: Get.height,
      width: Get.width,
      duration: _animationDuration,
      child: Column(
        children: [
          const VerticalSpacer(space: 10),
          _sectionTitle(),
          const VerticalSpacer(),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    focusNode: _fieldNode,
                    controller: _fieldController,
                    decoration: InputDecoration(
                      labelText: widget.title,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    onChanged: (value) {
                      var userLoc = Get.find<NewTripBookingController>().currentLatLng;

                      _searchPlaceBouncer.run(() {
                        var placeController = PlaceController();
                        placeController
                            .getNearbyPlaces(
                          userLocation: userLoc!,
                          keyword: value,
                        )
                            .then((value) {
                          setState(() {
                            places = value;
                          });
                        });
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: OutlinedButton(
              onPressed: () {
                _fieldNode.unfocus();
                setState(() {
                  _locationBy = LocationBy.map;
                });
              },
              child: const Text('Open on Map'),
              style: OutlinedButton.styleFrom(
                minimumSize: Size(Get.width, 50),
              ),
            ),
          ),
          const VerticalSpacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextButton(
              child: const Text('Continue'),
              onPressed: widget.onContinue,
              style: TextButton.styleFrom(
                minimumSize: Size(Get.width, 50),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: places.length + 1,
              itemBuilder: (context, index) {
                if (index == places.length) return const VerticalSpacer(space: 16);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          _fieldController.text = places[index].address;
                          widget.onLocationSelectedByPlace(places[index]);
                        },
                        leading: Container(
                          height: 25,
                          width: 25,
                          child: Icon(
                            Icons.place,
                            color: context.theme.colorScheme.onTertiary,
                            size: 15.0,
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: context.theme.colorScheme.tertiary,
                          ),
                        ),
                        title: Text(places[index].name),
                        horizontalTitleGap: 1.0,
                        subtitle: Text(places[index].address),
                      ),
                      const Divider(height: 0.5),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Container _locationByMap() {
    return Container(
      height: ResponsiveSize.height(100),
      width: Get.width,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      child: Column(
        children: <Widget>[
          _sectionTitle(),
          const VerticalSpacer(),
          OutlinedButton(
            child: const Text('Set'),
            onPressed: () async {
              var logic = Get.find<NewTripBookingController>();
              widget.onLocationSelectedByMap();
              logic.getAddressFromLatLng(logic.currentCameraLatLng).then((value) {
                _fieldController.text = value as String;
              });
            },
            style: OutlinedButton.styleFrom(
              minimumSize: Size(Get.width, 50),
            ),
          ),
          const VerticalSpacer(),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  child: const Text('Location by place'),
                  onPressed: () {
                    setState(() {
                      _locationBy = LocationBy.place;
                    });
                  },
                  style: TextButton.styleFrom(
                    minimumSize: Size(Get.width, 50),
                  ),
                ),
              ),
              const HorizontalSpacer(),
              Expanded(
                child: TextButton(
                  child: const Text('Continue'),
                  onPressed: widget.onContinue,
                  style: TextButton.styleFrom(
                    minimumSize: Size(Get.width, 50),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Center _sectionTitle() {
    return Center(
      child: Text(
        '${widget.title} Location',
        style: AppTextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
    );
  }
}
