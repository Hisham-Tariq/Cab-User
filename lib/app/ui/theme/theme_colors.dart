// ignore_for_file: non_abstract final Colorant_identifier_names, prefer_abstract final Color_abstract final Colorructors

import 'package:flutter/material.dart';

abstract class ThemeColors {
  Color get surface1 => ElevationOverlay.colorWithOverlay(surface, primary.withOpacity(0.05), 3);
  Color get surface2 => ElevationOverlay.colorWithOverlay(surface, primary.withOpacity(0.08), 3);
  Color get surface3 => ElevationOverlay.colorWithOverlay(surface, primary.withOpacity(0.11), 3);
  Color get surface4 => ElevationOverlay.colorWithOverlay(surface, primary.withOpacity(0.12), 3);
  Color get surface5 => ElevationOverlay.colorWithOverlay(surface, primary.withOpacity(0.14), 3);

  abstract final Color primary;
  abstract final Color onPrimary;
  abstract final Color primaryContainer;
  abstract final Color onPrimaryContainer;
  abstract final Color secondary;
  abstract final Color onSecondary;
  abstract final Color secondaryContainer;
  abstract final Color onSecondaryContainer;
  abstract final Color tertiary;
  abstract final Color onTertiary;
  abstract final Color tertiaryContainer;
  abstract final Color onTertiaryContainer;
  abstract final Color error;
  abstract final Color errorContainer;
  abstract final Color onError;
  abstract final Color onErrorContainer;
  abstract final Color background;
  abstract final Color onBackground;
  abstract final Color surface;
  abstract final Color onSurface;
  abstract final Color surfaceVariant;
  abstract final Color onSurfaceVariant;
  abstract final Color outline;
  abstract final Color inverseOnSurface;
  abstract final Color inverseSurface;
}
