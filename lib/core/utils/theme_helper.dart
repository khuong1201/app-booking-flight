import 'package:flutter/services.dart';

class ThemeHelper {
  static bool isDarkBackground(Color color) {
    double luminance = (0.2126 * color.r / 255) +
        (0.7152 * color.g / 255) +
        (0.0722 * color.b / 255);
    return luminance < 0.5;
  }

  static void updateStatusBar(Color backgroundColor) {
    SystemUiOverlayStyle overlayStyle = isDarkBackground(backgroundColor)
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;

    SystemChrome.setSystemUIOverlayStyle(overlayStyle);
  }
}
