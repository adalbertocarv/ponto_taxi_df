import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/mapa_controller.dart';
import '../../controllers/modo_app_controller.dart';
import '../../providers/themes/tema_provider.dart';
import '../screens/selecao_formulario.dart';
import '../../../models/constants/app_constants.dart';

class BotaoConfirmar extends StatefulWidget {
  const BotaoConfirmar({super.key});

  @override
  State<BotaoConfirmar> createState() => _BotaoConfirmarState();
}

class _BotaoConfirmarState extends State<BotaoConfirmar> {
  bool _isProcessing = false;

  // Helper method para calcular a posição do botão
  double _calculateBottomPosition(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return bottomPadding + AppConstants.navigationBarAltura + AppConstants.buttonEspacamento;
  }

  @override
  Widget build(BuildContext context) {
    final mapaController = context.watch<MapaController>();
    final tema = context.watch<ThemeProvider>();
    final modo = context.watch<ModoAppController>();

    // só aparece no modo Cadastro
    if (!modo.isCadastro) return const SizedBox.shrink();

    final bool esperandoConfirmar = mapaController.iconeVisivel; // TRUE antes do 1º clique

    return Positioned(
      bottom: _calculateBottomPosition(context),
      left: AppConstants.buttonHorizontalPadding,
      right: AppConstants.buttonHorizontalPadding,
      child: esperandoConfirmar
          ? _botaoConfirmar(mapaController, tema)          // 1-a etapa
          : _botoesCadastrarExcluir(mapaController, tema), // 2-a etapa
    );
  }

  /// 1ª etapa – confirma e adiciona o marker
  Widget _botaoConfirmar(MapaController mapa, ThemeProvider tema) {
    return SizedBox(
      height: AppConstants.buttonHeight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: tema.primaryColor),
        onPressed: _isProcessing
            ? null
            : () async {
          setState(() => _isProcessing = true);
          mapa.adicionarMarkerNoCentro();      // adiciona + dá zoom
          await Future.delayed(AppConstants.buttonProcessingDelay);
          setState(() => _isProcessing = false);
        },
        child: _isProcessing
            ? const _Loader()
            : const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.control_point_duplicate,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 8), // espaçamento entre ícone e texto
            Text(
              'C O N F I R M A R',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
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
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w800,
                ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: tema.primaryColor,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SelecaoForm(pontos: mapa.markers),
                ),
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
  const _Loader();
  @override
  Widget build(BuildContext context) => const SizedBox(
    width: AppConstants.loaderSize,
    height: AppConstants.loaderSize,
    child: CircularProgressIndicator(
      color: Colors.white,
      strokeWidth: AppConstants.loaderStrokeWidth,
    ),
  );
}