import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../../controllers/tela_inicio_controller.dart';

class SubMenu extends StatelessWidget {
   SubMenu({super.key});
  final controller = TelaInicioController();

  @override
  Widget build(BuildContext context) {
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
            backgroundColor: Colors.blueAccent,
            child: const Icon(
              Icons.map_outlined,
              color: Colors.white,
            ),
            label: 'Mapa Satélite',
            onTap: () => print('Mapa Satélite'),
          ),
          SpeedDialChild(
            backgroundColor: Colors.blueAccent,
            child: const Icon(
              Icons.restart_alt_outlined,
              color: Colors.white,
            ),
            label: 'Atualizar localização',
            onTap: () => print('Atualizar localização'),
          ),
        ],
      ),
    );
  }
}
