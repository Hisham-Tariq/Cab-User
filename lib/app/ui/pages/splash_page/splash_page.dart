import 'package:flutter/services.dart';

import '../../global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/controllers.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      context.theme.brightness == Brightness.dark
          ? SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: context.theme.colorScheme.primary,
              systemNavigationBarColor: context.theme.colorScheme.surface,
              systemNavigationBarIconBrightness: Brightness.light,
            )
          : SystemUiOverlayStyle.light.copyWith(
              statusBarColor: context.theme.colorScheme.primary,
              systemNavigationBarColor: context.theme.colorScheme.surface,
              systemNavigationBarIconBrightness: Brightness.dark,
            ),
    );
    return const Material(
      child: Center(
        child: AppName(),
      ),
    );
  }
}
