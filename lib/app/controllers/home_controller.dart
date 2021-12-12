import 'dart:async';

import 'package:driving_app_its/app/ui/global_widgets/debouncer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  Debouncer onBackButtonPressedDebouncer = Debouncer(miliseconds: 300);
  Timer? doubleTapBackTimer;
}
