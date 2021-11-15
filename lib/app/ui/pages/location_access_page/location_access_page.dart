import 'package:driving_app_its/app/ui/generated/assets.dart';
import 'package:driving_app_its/app/ui/global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../controllers/location_access_controller.dart';

class LocationAccessPage extends GetView<LocationAccessController> {
  const LocationAccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const VerticalSpacer(),
            SvgPicture.asset(
              Assets.svgLocation,
              height: 300,
            ),
            const VerticalSpacer(space: 32.0),
            const Text(
              'Location Services',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18.0,
              ),
            ),
            const VerticalSpacer(space: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                'We need to know where you are in order to provide you fast cab service',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14.0,
                ),
              ),
            ),
            const VerticalSpacer(space: 48.0),
            TextButton(
              child: const Text('Grant Access'),
              onPressed: controller.handleGrantAcess,
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                primary: Colors.white,
                minimumSize: const Size(200, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
