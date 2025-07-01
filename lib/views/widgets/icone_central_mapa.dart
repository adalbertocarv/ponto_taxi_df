import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/modo_app_controller.dart';

class IconeCentralMapa extends StatelessWidget {


  const IconeCentralMapa({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final modoApp = context.watch<ModoAppController>();

    if (!modoApp.isCadastro) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Camada de baixo: O Círculo
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(0.3),
                border: Border.all(
                  color: Colors.blue,
                  width: 2,
                ),
              ),
            ),
            // Camada de cima: O Ícone
            Transform.translate(
              offset: const Offset(0, -20),
              child: Icon(
                Icons.location_pin,
                color: Colors.red,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}