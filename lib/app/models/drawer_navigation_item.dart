import 'package:flutter/material.dart';

enum DrawerItemType {
  callAble,
  viewBased,
}

class DrawerNavigationItem {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final Widget? widget;
  final DrawerItemType itemType;
  bool isSelected;
  bool showAppBar;

  DrawerNavigationItem(
    this.title,
    this.icon,
    this.itemType, {
    this.isSelected = false,
    this.showAppBar = true,
    this.widget,
    this.onTap,
  });
}
