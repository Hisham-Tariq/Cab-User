import 'package:driving_app_its/app/ui/generated/assets.dart';
import 'package:driving_app_its/app/ui/global_widgets/global_widgets.dart';
import 'package:driving_app_its/app/ui/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/location_access_controller.dart';
import '../../theme/text_theme.dart';

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
              height: ResponsiveSize.height(150),
            ),
            const VerticalSpacer(space: 12),
            Text(
              'Location Services',
              style: AppTextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 24.0,
              ),
            ),
            const VerticalSpacer(space: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                'We need to know where you are in order to provide you fast cab service',
                textAlign: TextAlign.center,
                style: AppTextStyle(
                  fontSize: 14.0,
                ),
              ),
            ),
            const VerticalSpacer(space: 12),
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
