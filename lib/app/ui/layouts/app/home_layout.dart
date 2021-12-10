import 'package:driving_app_its/app/controllers/navigation_controller.dart';
import 'package:driving_app_its/app/ui/global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeLayout extends GetView<NavigationController> {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        key: controller.scaffoldState,
        drawer: const AppDrawer(),
        appBar: controller.selectedDrawerItem.value.showAppBar ? AppBar() : null,
        body: controller.selectedDrawerItem.value.widget,
      ),
    );
  }
}
