import 'package:flutter/material.dart';

import 'botao_norte.dart';
import 'centralizar_mapa.dart';

class BotoesGeral extends StatelessWidget {
  const BotoesGeral({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CentralizarMapa(),
        BotaoNorte(),
      ],
    );
  }
}
