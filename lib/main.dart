import 'package:flutter/material.dart';

import 'views/screens/telainicio.dart';
import 'package:provider/provider.dart';
import 'providers/themes/tema_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Ponto Certo - Táxi',
          theme: themeProvider.currentTheme,
          home: TelaInicio(),
        );
      },
    );
  }
}