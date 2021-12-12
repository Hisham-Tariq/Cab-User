import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme_data.dart';
import 'theme.dart';
import 'colors/colors_interface.dart';
// import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

enum AppThemes { light, dark, system }

class ThemeSpecifications {
  final ThemeColors colors;
  final Brightness brightness;

  ThemeSpecifications(this.colors, this.brightness);
}

class ThemeController extends GetxController {
  final BuildContext? context;
  ThemeController(this.context);

  static final Map<AppThemes, ThemeSpecifications> _themes = {
    AppThemes.light: ThemeSpecifications(LightThemeColors(), Brightness.light),
    AppThemes.dark: ThemeSpecifications(DarkThemeColors(), Brightness.dark),
  };

  final _getStorage = GetStorage();
  final storageKey = 'GimsTheme';
  final currentThemeMode = AppThemes.system.obs;

  // ignore: non_constant_identifier_names
  static ThemeColors CurrentTheme(BuildContext context) {
    var controller = Get.find<ThemeController>();
    if (controller.currentThemeMode.value == AppThemes.system) {
      if (context.theme.brightness == Brightness.light) {
        return _themes[AppThemes.light]!.colors;
      } else {
        return _themes[AppThemes.dark]!.colors;
      }
    } else {
      return _themes[controller.currentThemeMode.value]!.colors;
    }
  }

  @override
  onInit() {
    super.onInit();
    var window = WidgetsBinding.instance!.window;
    window.onPlatformBrightnessChanged = () {
      if (isSystemThemeModeEnabled) {
        if (Get.isDialogOpen!) Get.back();
        _updateTheme();
      }
    };
    _updateTheme();
  }

  bool get isSystemThemeModeEnabled => getThemeMode() == AppThemes.system;
  ThemeData get lightTheme => CustomTheme.create(_themes[AppThemes.light]!.colors, Brightness.light);
  ThemeData get darkTheme => CustomTheme.create(_themes[AppThemes.dark]!.colors, Brightness.dark);

  Brightness get platformBrightness => WidgetsBinding.instance!.window.platformBrightness;

  // Save the ThemeMode to the Storage for start of the app
  void saveThemeMode(AppThemes themeMode, [BuildContext? context]) {
    _getStorage.write(storageKey, themeMode.index);
    currentThemeMode.value = themeMode;
  }

  AppThemes getThemeMode() {
    return getThemeModeFromIndex(_getStorage.read(storageKey) ?? currentThemeMode.value.index);
  }

  changeAppTheme(AppThemes themeMode) {
    currentThemeMode.value = themeMode;
    saveThemeMode(themeMode);
    _updateTheme();
  }

  _updateTheme() {
    switch (getThemeMode()) {
      case AppThemes.light:
        print("Light");
        Get.changeTheme(lightTheme);
        break;
      case AppThemes.dark:
        print("Dark");
        Get.changeTheme(darkTheme);
        break;
      case AppThemes.system:
        if (platformBrightness == Brightness.light) {
          print("System-Light");
          Get.changeTheme(lightTheme);
        } else {
          print("System-Dark");
          Get.changeTheme(darkTheme);
        }
        break;
    }
    update();
  }

  AppThemes getThemeModeFromIndex(int index) {
    if (index == AppThemes.system.index) {
      return AppThemes.system;
    } else if (index == AppThemes.light.index) {
      return AppThemes.light;
    } else {
      return AppThemes.dark;
    }
  }

  String activeThemeModeName() {
    if (currentThemeMode.value == AppThemes.system) {
      return 'System Default';
    } else if (currentThemeMode.value == AppThemes.light) {
      return 'Light';
    } else {
      return 'Dark';
    }
  }
}
