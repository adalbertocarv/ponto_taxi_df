import 'package:flutter/material.dart';
import 'package:ponto_taxi_df/views/screens/formulario_taxi.dart';
import 'package:provider/provider.dart';
import '../../controllers/modo_app_controller.dart';
import '../../providers/themes/tema_provider.dart';
import '../../controllers/mapa_controller.dart';

class BotaoConfirmar extends StatefulWidget {
  const BotaoConfirmar({super.key});

  @override
  State<BotaoConfirmar> createState() => _BotaoConfirmarState();
}

class _BotaoConfirmarState extends State<BotaoConfirmar> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final mapaController = context.watch<MapaController>();
    final themeProvider = Provider.of<ThemeProvider>(context);
    final modoApp = context.watch<ModoAppController>();

    if (!modoApp.isCadastro) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 90,
      left: 36,
      right: 36,
      child: SizedBox(
        height: 56,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:themeProvider.primaryColor
          ),
          onPressed: _isProcessing ? null : () async {
            setState(() {
              _isProcessing = true;
            });

            // Adiciona marker exatamente onde o IconeCentralMapa está posicionado
            // O próprio método já mostra a mensagem de sucesso
            mapaController.adicionarMarkerNoCentro();

            // Pequeno delay para suavizar a animação
            await Future.delayed(const Duration(milliseconds: 100));

            setState(() {
              _isProcessing = false;
            });
            Navigator.push(context, MaterialPageRoute(builder: (context) => FormularioTaxi()));
          },
          child: _isProcessing
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
              : Text(
mapaController.iconeVisivel
            ? 'Confirmar Ponto' : 'Cadastrar',
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}