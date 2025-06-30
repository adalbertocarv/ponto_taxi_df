import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  static const Color primaryColor = Color(0xff5D89D5);
  static const Color primaryColorDark = Color(0xff3A5A9E); // Tom mais escuro da cor primária

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme => _isDarkMode ? darkTheme : lightTheme;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setTheme(bool isDark) {
    _isDarkMode = isDark;
    notifyListeners();
  }

  // Tema Claro
  ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primarySwatch: _createMaterialColor(primaryColor),
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 2,
      centerTitle: true,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: primaryColor,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.3),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ),
  );

  // Tema Escuro
  ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primarySwatch: _createMaterialColor(primaryColorDark),
    primaryColor: primaryColorDark,
    scaffoldBackgroundColor: const Color(0xff121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColorDark,
      foregroundColor: Colors.white,
      elevation: 2,
      centerTitle: true,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: primaryColorDark,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColorDark,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColorDark,
        foregroundColor: Colors.white,
      ),
    ),
    cardTheme: const CardThemeData(
      color: Color(0xff1E1E1E),
      elevation: 4,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColorDark,
      brightness: Brightness.dark,
    ),
  );

  // Método auxiliar para criar MaterialColor
  MaterialColor _createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }

    return MaterialColor(color.value, swatch);
  }
}