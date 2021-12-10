import 'package:flutter/material.dart';

class DrawerNavigationItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Widget widget;
  bool isSelected;
  bool showAppBar;

  DrawerNavigationItem(
    this.title,
    this.icon,
    this.onTap,
    this.widget, {
    this.isSelected = false,
    this.showAppBar = true,
  });
}
