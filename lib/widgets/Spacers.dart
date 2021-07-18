import 'package:flutter/material.dart';

class VerticalAppSpacer extends StatelessWidget {
  const VerticalAppSpacer({Key? key, this.space = 8.0}) : super(key: key);
  final double space;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: space,
    );
  }
}

class HorizontalAppSpacer extends StatelessWidget {
  const HorizontalAppSpacer({Key? key, this.space = 8.0}) : super(key: key);
  final double space;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: space,
    );
  }
}
