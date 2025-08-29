import 'package:flutter/material.dart';
import 'package:ponto_taxi_df/taxi/providers/themes/tema_provider.dart';
import 'package:provider/provider.dart';
import '../../controllers/modo_app_controller.dart';
import '../widgets/notificacoes.dart';

class Registros extends StatefulWidget {
  const Registros({super.key});

  @override
  State<Registros> createState() => _RegistrosState();
}

class _RegistrosState extends State<Registros> {

  @override
  Widget build(BuildContext context) {
    final modoApp = context.watch<ModoAppController>();
    final themeProvider = context.watch<ThemeProvider>();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment, color: themeProvider.primaryColor, size: 26),
                  const SizedBox(width: 20),
                  Text(
                    'R E G I S T R O S',
                    style: TextStyle(
                      fontSize: 24,
                      color: themeProvider.primaryColor,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Stack(
                  children: [
                 Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Nenhum registro hoje',
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w800,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Text(
                        'Pontos cadastrados ou em fila de envio estarão aqui disponíveis para visualização',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                    ),
                    modoApp.isCadastro
                        ? Image.asset('assets/images/bus_stop_azul.webp', height: 250,)
                        : Image.asset('assets/images/bus_stop_verde.webp', height: 250,),
                  ],
                ),
              ),
                    const Notificacao(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}