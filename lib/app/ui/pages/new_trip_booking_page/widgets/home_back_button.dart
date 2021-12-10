import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';

class HomeBackButton extends StatelessWidget {
  const HomeBackButton({Key? key, required this.onTap}) : super(key: key);

  final Callback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: context.theme.colorScheme.primary,
        radius: 25,
        child: Icon(
          Icons.arrow_back,
          size: 20,
          color: context.theme.colorScheme.onPrimary,
        ),
      ),
    );
  }
}
