import 'package:flutter/material.dart';
import 'package:ponto_taxi_df/views/screens/formulario_taxi.dart';
import 'package:provider/provider.dart';

import '../../controllers/mapa_controller.dart';
import '../../controllers/modo_app_controller.dart';
import '../../providers/themes/tema_provider.dart';

class BotaoConfirmar extends StatefulWidget {
  const BotaoConfirmar({super.key});

  @override
  State<BotaoConfirmar> createState() => _BotaoConfirmarState();
}

class _BotaoConfirmarState extends State<BotaoConfirmar> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final mapa = context.watch<MapaController>();
    final tema = context.watch<ThemeProvider>();
    final modo = context.watch<ModoAppController>();

    // só aparece no modo Cadastro
    if (!modo.isCadastro) return const SizedBox.shrink();

    final bool esperandoConfirmar = mapa.iconeVisivel; // TRUE antes do 1º clique

    return Positioned(
      bottom: 90,
      left: 36,
      right: 36,
      child: esperandoConfirmar
          ? _botaoConfirmar(mapa, tema)          // 1-a etapa
          : _botoesCadastrarExcluir(mapa, tema), // 2-a etapa
    );
  }

  /// 1ª etapa – confirma e adiciona o marker
  Widget _botaoConfirmar(MapaController mapa, ThemeProvider tema) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: tema.primaryColor),
        onPressed: _isProcessing
            ? null
            : () async {
          setState(() => _isProcessing = true);
          mapa.adicionarMarkerNoCentro();      // adiciona + dá zoom
          await Future.delayed(const Duration(milliseconds: 300));
          setState(() => _isProcessing = false);
        },
        child: _isProcessing
            ? const _Loader()
            : const Text('Confirmar Ponto',
            style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
    );
  }

  /// 2ª etapa – pode cadastrar ou excluir (desfazer)
  Widget _botoesCadastrarExcluir(MapaController mapa, ThemeProvider tema) {
    return Row(
      children: [
        // EXCLUIR  ➜ volta ao estado inicial
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.delete_forever_outlined, color: Colors.white),
            label: const Text('Excluir',
                style: TextStyle(fontSize: 16, color: Colors.white)),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              side: BorderSide.none,
            ),
            onPressed: () => mapa.desfazerUltimoPonto(), // volta o ícone central
          ),
        ),
        const SizedBox(width: 12),
        // CADASTRAR  ➜ vai para o formulário
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.save_alt_rounded, color: Colors.white),
            label: const Text('Cadastrar',
                style: TextStyle(fontSize: 16, color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: tema.primaryColor,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FormularioTaxi()),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// loader reutilizado
class _Loader extends StatelessWidget {
  const _Loader({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const SizedBox(
    width: 20,
    height: 20,
    child: CircularProgressIndicator(
      color: Colors.white,
      strokeWidth: 2,
    ),
  );
}
