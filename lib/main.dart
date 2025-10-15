import 'package:flutter/material.dart';
import 'package:ponto_taxi_df/taxi/controllers/mapa_controller.dart';
import 'package:ponto_taxi_df/taxi/controllers/modo_app_controller.dart';
import 'package:ponto_taxi_df/taxi/controllers/perfil_controller.dart';
import 'package:ponto_taxi_df/taxi/providers/autenticacao/auth_provider.dart';
import 'package:ponto_taxi_df/taxi/providers/themes/tema_provider.dart';
import 'package:ponto_taxi_df/taxi/views/screens/home/tela_inicio.dart';
import 'package:ponto_taxi_df/taxi/views/screens/login.dart';
import 'package:ponto_taxi_df/taxi/views/screens/selecao_modo_app.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ModoAppController()),
        ChangeNotifierProvider(create: (_) => MapaController()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PerfilController()),
      ],
      child: PontoCertoTaxi(),
    ),
  );
}

class PontoCertoTaxi extends StatelessWidget {
  const PontoCertoTaxi({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Ponto Certo - Táxi',
              theme: themeProvider.currentTheme,
              // home: authProvider.isAuthenticated ? TelaInicioPage() : TelaInicioPage(),
             home: authProvider.isAuthenticated ? SelectionScreen() : LoginScreen(),
            );
          },
        );
      },
    );
  }
}