export 'common_theme.dart';
export 'light_theme.dart';
export 'dark_theme.dart';

import 'package:flutter/material.dart';
import 'base_theme.dart';

import 'theme.dart';

ThemeData lightTheme = CustomTheme.create(LightThemeColors(), Brightness.light);
ThemeData darkTheme = CustomTheme.create(DarkThemeColors(), Brightness.dark);
