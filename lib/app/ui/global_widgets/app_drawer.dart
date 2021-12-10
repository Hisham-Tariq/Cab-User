import 'package:driving_app_its/app/controllers/navigation_controller.dart';
import 'package:driving_app_its/app/models/drawer_navigation_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/text_theme.dart';
import 'spacers.dart';

class AppDrawer extends GetView<NavigationController> {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavigationController>(
      init: NavigationController(),
      initState: (_) {},
      builder: (_) {
        return Drawer(
          child: SafeArea(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: Row(
                    children: [
                      Text(
                        "C",
                        style: AppTextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 30,
                          color: context.theme.colorScheme.primary,
                        ),
                      ),
                      Text(
                        "AB",
                        style: AppTextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.grey),
                const SizedBox(height: 20),
                for (DrawerNavigationItem item in controller.drawerNavigationItems)
                  _DrawerTile(
                    item: item,
                    onTap: () async {
                      Get.back();
                      await Future.delayed(const Duration(milliseconds: 250));
                      item.onTap();
                      controller.onDrawerItemClicked(item);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    Key? key,
    required this.item,
    required this.onTap,
  }) : super(key: key);

  final DrawerNavigationItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Column(
        children: [
          ListTile(
            title: Text(item.title),
            leading: Icon(item.icon),
            selected: item.isSelected,
            selectedColor: context.theme.colorScheme.onPrimary,
            selectedTileColor: context.theme.colorScheme.primary,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.horizontal(
              right: Radius.circular(9999.0),
            )),
            onTap: onTap,
          ),
          const VerticalSpacer(space: 1),
        ],
      ),
    );
  }
}
