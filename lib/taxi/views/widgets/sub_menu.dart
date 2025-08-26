import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import '../../controllers/mapa_controller.dart';
import '../../controllers/modo_app_controller.dart';
import '../../controllers/tela_inicio_controller.dart';
import '../../providers/themes/tema_provider.dart';
import 'confirmacao_modo_app.dart';

class SubMenu extends StatefulWidget {
   const SubMenu({super.key});

  @override
  State<SubMenu> createState() => _SubMenuState();
}

class _SubMenuState extends State<SubMenu> {
  final controller = TelaInicioController();

  @override
  Widget build(BuildContext context) {
    final modoApp = context.watch<ModoAppController>();
    final themeProvider = context.watch<ThemeProvider>();
    final mapaController = context.watch<MapaController>();

    return  Transform.translate(
      offset: const Offset(0, 12),
      child: SpeedDial(
        direction: SpeedDialDirection.up,

        backgroundColor: Colors.transparent,
        overlayColor: Colors.black,
        overlayOpacity: 0.8,
        buttonSize: const Size(45, 45),
        childrenButtonSize: const Size(50, 50),
        spacing: 8,
        spaceBetweenChildren: 4,
        elevation: 0,
        openCloseDial: controller.isDialOpen,
        children: [
          SpeedDialChild(
            backgroundColor: themeProvider.primaryColor,
            child: const Icon(
              Icons.restart_alt_outlined,
              color: Colors.white,
            ),
            label: 'Atualizar localização',
              onTap: () {
                mapaController.obterLocalizacaoUsuario();
            }
    ),

          SpeedDialChild(
            backgroundColor: modoApp.isCadastro ? Colors.green : Colors.blueAccent,
            child: Icon(
              modoApp.isCadastro ? Icons.assignment_turned_in_rounded : Icons.add_home,
              color: Colors.white,
            ),
            label: modoApp.isCadastro ? 'Mudar para Vistoria' : 'Mudar para Cadastro',
              onTap: () {
                // Exibe o diálogo de confirmação quando o item for tocado
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ConfirmacaoDialog(
                        modoApp: modoApp,
                        themeProvider: themeProvider,
                      );
                    });
              }),
            ],
      ),
    );
  }
}
