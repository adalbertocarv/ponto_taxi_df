import 'package:flutter/material.dart';
import 'package:ponto_taxi_df/controllers/modo_app_controller.dart';

class ThemeProvider extends ChangeNotifier {
  // Cores base
  static const Color colorAzul = Color(0xff5D89D5);
  static const Color colorAzulDark = Color(0xff3A5A9E);
  static const Color colorVerde = Color(0xFF27AE60);
  static const Color colorVerdeDark = Color(0xFF1C7D45);

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  ModoApp _modoApp = ModoApp.cadastro;
  ModoApp get modoApp => _modoApp;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setTheme(bool isDark) {
    _isDarkMode = isDark;
    notifyListeners();
  }

  void setModoApp(ModoApp modo) {
    _modoApp = modo;
    notifyListeners();
  }

  ThemeData get currentTheme => _isDarkMode ? darkTheme : lightTheme;

  //  Cor primária dinâmica
  Color get primaryColor {
    if (_modoApp == ModoApp.cadastro) {
      return _isDarkMode ? colorAzulDark : colorAzul;
    } else {
      return _isDarkMode ? colorVerdeDark : colorVerde;
    }
  }

  MaterialColor get primarySwatch => _createMaterialColor(primaryColor);

  //  Tema Claro
  ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primarySwatch: primarySwatch,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 2,
      centerTitle: true,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: primaryColor,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
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
      shadowColor: Colors.grey.withValues(alpha: 0.3),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ),
  );

  //  Tema Escuro
  ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primarySwatch: primarySwatch,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: const Color(0xff121212),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 2,
      centerTitle: true,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: primaryColor,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    ),
    cardTheme: const CardThemeData(
      color: Color(0xff1E1E1E),
      elevation: 4,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    ),
  );

  // 🛠️ Material Color Generator
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
