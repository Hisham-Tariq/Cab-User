import 'package:driving_app_its/customization/customization.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/models.dart';
import '../../../controller/controller.dart';
import '../../../widgets/widgets.dart';
import 'package:flutter/material.dart';

enum LocationBy { place, map }

class SetLocation extends StatefulWidget {
  const SetLocation({
    Key? key,
    required this.title,
    required this.onContinue,
    required this.onLocationSelectedByPlace,
    required this.onLocationSelectedByMap,
    required this.onBack,
  }) : super(key: key);
  final String title;
  final Function onLocationSelectedByPlace;
  final Function onLocationSelectedByMap;
  final Callback onContinue;
  final Callback onBack;

  @override
  State<SetLocation> createState() => _SetLocationState();
}

class _SetLocationState extends State<SetLocation> {
  List<Place> places = [];
  static const _animationDuration = Duration(milliseconds: 400);

  final _fieldController = TextEditingController();
  LocationBy _locationBy = LocationBy.place;
  final _searchPlaceBouncer = Debouncer(miliseconds: 300);

  final _fieldNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
          Positioned(
            top: 10,
            left: 10,
            child: CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.green,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: widget.onBack,
              ),
            ),
          ),
        ],
      ),
    );
  }

  AnimatedContainer _locationByPlace() {
    return AnimatedContainer(
      decoration: const BoxDecoration(color: Colors.white),
      height: Get.height,
      width: Get.width,
      duration: _animationDuration,
      child: Column(
        children: [
          const VerticalAppSpacer(),
          _sectionTitle(),
          const VerticalAppSpacer(),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    focusNode: _fieldNode,
                    controller: _fieldController,
                    cursorHeight: 10,
                    decoration: InputDecoration(
                      labelText: widget.title,
                      labelStyle: const TextStyle(color: Colors.green),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    onChanged: (value) {
                      var userLoc =
                          Get.find<NewTripBookingController>().currentLatLng;

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
            child: FullOutlinedTextButton(
              onPressed: () {
                _fieldNode.unfocus();
                setState(() {
                  _locationBy = LocationBy.map;
                });
              },
              text: 'Open on Map',
            ),
          ),
          const VerticalAppSpacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: FullTextButton(
              text: 'Continue',
              onPressed: widget.onContinue,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: places.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () =>
                            widget.onLocationSelectedByPlace(places[index]),
                        leading: Container(
                          height: 25,
                          width: 25,
                          child: const Icon(
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
      height: 200,
      width: Get.width,
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.elliptical(400, 90),
        ),
      ),
      child: Column(
        children: <Widget>[
          _sectionTitle(),
          const VerticalAppSpacer(),
          FullOutlinedTextButton(
            text: 'Set',
            onPressed: () async {
              var logic = Get.find<NewTripBookingController>();
              widget.onLocationSelectedByMap();
              logic
                  .getAddressFromLatLng(logic.currentCameraLatLng)
                  .then((value) {
                _fieldController.text = value as String;
              });
            },
          ),
          const VerticalAppSpacer(),
          Row(
            children: [
              Expanded(
                child: FullTextButton(
                  text: 'Location by place',
                  onPressed: () {
                    setState(() {
                      _locationBy = LocationBy.place;
                    });
                  },
                ),
              ),
              const HorizontalAppSpacer(),
              Expanded(
                child: FullTextButton(
                  text: 'Continue',
                  onPressed: widget.onContinue,
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
        style: GoogleFonts.catamaran(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
    );
  }
}
