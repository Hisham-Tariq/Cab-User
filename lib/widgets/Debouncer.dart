import 'dart:async';

import 'package:flutter/material.dart';

class Debouncer {
  final int? miliseconds;
  VoidCallback? action;
  Timer? _timer;
  Debouncer({this.miliseconds});

  run(VoidCallback action) {
    if (_timer != null) _timer!.cancel();
    _timer = Timer(Duration(milliseconds: miliseconds!), action);
  }
}
