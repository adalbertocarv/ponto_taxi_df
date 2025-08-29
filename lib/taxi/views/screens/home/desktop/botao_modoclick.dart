import 'package:flutter/material.dart';
import 'package:provider/provider.dart';import '../../../../controllers/mapa_controller.dart';
import '../../../../controllers/modo_app_controller.dart';
import '../../../../models/constants/app_constants.dart';
import '../../../../providers/themes/tema_provider.dart';
import '../../selecao_formulario.dart';

class BotaoModoClick extends StatelessWidget {
  const BotaoModoClick({super.key});
  static const _desktopBreakpoint = 780.0;

  @override
  Widget build(BuildContext context) {
    final mapaController = context.watch<MapaController>();
    final tema = context.watch<ThemeProvider>();
    final modo = context.watch<ModoAppController>();
    final width = MediaQuery.of(context).size.width;

    // Só mostra no modo Cadastro
    if (!modo.isCadastro|| width <= _desktopBreakpoint) return const SizedBox.shrink();
    // Se tem markers e não está no modo click, mostra os botões de ação
    if (mapaController.markers.isNotEmpty && !mapaController.modoClickMapa) {
      return _buildActionButtons(context, mapaController, tema, width);
    }

    // Senão, mostra o FAB para ativar modo click
    return _buildClickModeFAB(mapaController, tema);
  }

  /// FloatingActionButton para ativar modo click
  Widget _buildClickModeFAB(MapaController mapaController, ThemeProvider tema) {
    return Positioned(
      top: 250,
      right: 16,
      child: FloatingActionButton.extended(
        onPressed: () {
          mapaController.toggleModoClickMapa();
        },
        backgroundColor: mapaController.modoClickMapa
            ? Colors.orange
            : tema.primaryColor,
        icon: AnimatedRotation(
          turns: mapaController.modoClickMapa ? 0.5 : 0,
          duration: const Duration(milliseconds: 300),
          child: Icon(
            mapaController.modoClickMapa
                ? Icons.touch_app_outlined
                : Icons.add_location_alt_outlined,
            color: Colors.white,
          ),
        ),
        label: Text(
          mapaController.modoClickMapa ? 'Clique no Mapa' : 'Cadastrar',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Botões de ação (Excluir e Cadastrar) - similar ao BotaoConfirmar
  /// Botões de ação (Excluir e Cadastrar) - posicionados na base da tela
  Widget _buildActionButtons(BuildContext context, MapaController mapa, ThemeProvider tema, double width) {
    const double desktopBreakpoint = 780.0;
    final bool isDesktop = width >= desktopBreakpoint;

    // Helper method para calcular a posição do botão na base da tela
    double _calculateBottomPosition(BuildContext context) {
      final bottomPadding = MediaQuery.of(context).padding.bottom;
      return bottomPadding + AppConstants.navigationBarAltura + AppConstants.buttonEspacamento;
    }

    if (isDesktop) {
      // Layout horizontal também no desktop - posicionado na base
      return Positioned(
        bottom: _calculateBottomPosition(context),
        left: AppConstants.buttonHorizontalPadding,
        right: AppConstants.buttonHorizontalPadding,
        child: Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Row(
              children: [
                // EXCLUIR
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.delete_forever_outlined, color: Colors.white, size: 18),
                    label: const Text('Excluir',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      side: BorderSide.none,
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    ),
                    onPressed: () => mapa.desfazerUltimoPonto(),
                  ),
                ),
                const SizedBox(width: 12),
                // CADASTRAR
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save_alt_rounded, color: Colors.white, size: 18),
                    label: const Text('Cadastrar',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w800,
                        )),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tema.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
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
            ),
          ),
        ),
      );
    } else {
      // Layout horizontal para mobile - posicionado na base da tela
      return Positioned(
        bottom: _calculateBottomPosition(context),
        left: AppConstants.buttonHorizontalPadding,
        right: AppConstants.buttonHorizontalPadding,
        child: Row(
          children: [
            // EXCLUIR
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.delete_forever_outlined, color: Colors.white, size: 16),
                label: const Text('Excluir',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  side: BorderSide.none,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () => mapa.desfazerUltimoPonto(),
              ),
            ),
            const SizedBox(width: 12),
            // CADASTRAR
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save_alt_rounded, color: Colors.white, size: 16),
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
                  padding: const EdgeInsets.symmetric(vertical: 14),
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
        ),
      );
    }
  }
}

// Versão alternativa mais simples (apenas FAB que muda de função)
class BotaoModoClickSimples extends StatelessWidget {
  const BotaoModoClickSimples({super.key});

  @override
  Widget build(BuildContext context) {
    final mapaController = context.watch<MapaController>();
    final tema = context.watch<ThemeProvider>();
    final modo = context.watch<ModoAppController>();

    // Só mostra no modo Cadastro
    if (!modo.isCadastro) return const SizedBox.shrink();

    // Se tem markers, mostra botão para ir ao formulário
    if (mapaController.markers.isNotEmpty && !mapaController.modoClickMapa) {
      return FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SelecaoForm(pontos: mapaController.markers),
            ),
          );
        },
        backgroundColor: tema.primaryColor,
        icon: const Icon(Icons.save_alt_rounded, color: Colors.white),
        label: const Text(
          'Cadastrar',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    // Senão, mostra FAB para modo click
    return FloatingActionButton.extended(
      onPressed: () {
        mapaController.toggleModoClickMapa();
      },
      backgroundColor: mapaController.modoClickMapa
          ? Colors.orange
          : tema.primaryColor,
      icon: AnimatedRotation(
        turns: mapaController.modoClickMapa ? 0.5 : 0,
        duration: const Duration(milliseconds: 300),
        child: Icon(
          mapaController.modoClickMapa
              ? Icons.touch_app_outlined
              : Icons.add_location_alt_outlined,
          color: Colors.white,
        ),
      ),
      label: Text(
        mapaController.modoClickMapa ? 'Clique no Mapa' : 'Modo Click',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}