import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';

class MiddleScreenLocationIcon extends StatelessWidget {
  const MiddleScreenLocationIcon({Key? key, this.size = 30}) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size * 2,
      width: size * 2,
      child: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomCenter,
              width: double.infinity,
              child: Icon(
                Icons.location_on,
                size: size,
                color: context.theme.colorScheme.primary,
              ),
            ),
          ),
          const Expanded(
            child: SizedBox(
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
