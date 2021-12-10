import 'package:driving_app_its/app/controllers/controllers.dart';
import 'package:driving_app_its/app/ui/global_widgets/global_widgets.dart';
import 'package:driving_app_its/app/ui/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/text_theme.dart';

class TripAtIdleState extends StatelessWidget {
  const TripAtIdleState({Key? key, required this.onSchedule}) : super(key: key);
  final Callback onSchedule;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 250,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: context.theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(30.0),
          ),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -3),
              color: context.theme.colorScheme.onInverseSurface,
              blurRadius: 230.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Start Trip',
                style: AppTextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const VerticalSpacer(space: 16.0),
            Row(
              children: [
                Text(
                  "Welcome ",
                  style: AppTextStyle(
                    fontSize: ResponsiveSize.height(6),
                  ),
                ),
                Text(
                  GetUtils.capitalize(Get.find<UserController>().user.firstName!)!,
                  style: AppTextStyle(
                    fontSize: ResponsiveSize.height(6),
                    color: context.theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const VerticalSpacer(space: 16.0),
            GestureDetector(
              onTap: onSchedule,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                height: 80,
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(
                    20.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Where to?',
                          style: AppTextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ResponsiveSize.height(6),
                            color: context.theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: context.theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(
                            15.0,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Schedule',
                            style: AppTextStyle(
                              color: context.theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
