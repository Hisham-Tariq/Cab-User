import 'dart:async';
import 'dart:io';

import 'package:driving_app_its/app/controllers/home_controller.dart';
import 'package:driving_app_its/app/controllers/navigation_controller.dart';
import 'package:driving_app_its/app/ui/global_widgets/global_widgets.dart';
import 'package:driving_app_its/app/ui/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class HomeLayout extends GetView<NavigationController> {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        var controller = Get.find<HomeController>();
        if (controller.doubleTapBackTimer == null) {
          controller.doubleTapBackTimer = Timer(const Duration(milliseconds: 1500), () {
            controller.doubleTapBackTimer = null;
          });
          Fluttertoast.showToast(msg: "Tap again to exit");
        } else {
          return Future.value(true);
        }
        return Future.value(false);
      },
      child: Obx(
        () => Scaffold(
          key: controller.scaffoldState,
          drawer: const AppDrawer(),
          appBar: controller.selectedDrawerItem.value.showAppBar
              ? AppBar(
                  title: Text(
                    controller.selectedDrawerItem.value.title,
                    style: AppTextStyle(
                      color: context.theme.colorScheme.onPrimary,
                    ),
                  ),
                )
              : null,
          body: controller.selectedDrawerItem.value.widget,
        ),
      ),
    );
  }
}
