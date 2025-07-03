import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/mapa_controller.dart';
import '../../controllers/modo_app_controller.dart';
import '../../providers/themes/tema_provider.dart';

class ConfirmacaoDialog extends StatelessWidget {
  final ModoAppController modoApp;
  final ThemeProvider themeProvider;

  const ConfirmacaoDialog({
    super.key,
    required this.modoApp,
    required this.themeProvider,
  });

  @override
  Widget build(BuildContext context) {
    final mapaController = context.watch<MapaController>();

    return AlertDialog(
      title: const Text('Confirmação'),
      content: Text(
        'Tem certeza que deseja mudar para o modo ${modoApp.isCadastro ? 'Vistoria' : 'Cadastro'}?\n'
            'Dados não salvos serão perdidos.',
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop(); // Fechar o diálogo sem fazer nada
          },
        ),
        TextButton(
          style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
          child: const Text('Confirmar'),
          onPressed: () {
            Navigator.of(context).pop(); // Fechar o diálogo
            mapaController.desfazerUltimoPonto();
            // Realiza a troca de modo após confirmação
            if (modoApp.isCadastro) {
              modoApp.selecionarModoVistoria();
              themeProvider.setModoApp(ModoApp.vistoria);
            } else {
              modoApp.selecionarModoCadastro();
              themeProvider.setModoApp(ModoApp.cadastro);
            }
          },
        ),
      ],
    );
  }
}
