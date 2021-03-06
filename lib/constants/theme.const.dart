import 'package:flutter/material.dart';


const int _themePrimaryValue = 0xFF182245;

class ThemeColors {
  static Color primaryDark = Color(0xFF101630);
  static Color primary = Color(_themePrimaryValue);
  static Color primaryLight = Color(0xFF2E3858);
  static Color secondary = Color(0xFFF30294);
  static Color info = Color(0xFF00FFFC);
  static Color bg = Color(0xFF171E3B);
  static Color bg2 = Color(0xFF2E3858);

  static MaterialColor colors = MaterialColor(
    _themePrimaryValue,
    <int, Color>{
      50: Color(0xFFE3F2FD),
      100: Color(0xFFBBDEFB),
      200: Color(0xFF90CAF9),
      300: Color(0xFF64B5F6),
      400: Color(0xE9182245),
      500: Color(_themePrimaryValue),
      600: Color(0xFF1E88E5),
      700: Color(0xFF1976D2),
      800: Color(0xFF1565C0),
      900: Color(0xFF0D47A1),
    },
  );
}
