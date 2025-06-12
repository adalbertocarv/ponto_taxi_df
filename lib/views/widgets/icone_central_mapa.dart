import 'package:flutter/material.dart';

class IconeCentralMapa extends StatelessWidget {
  // Propriedade para receber o estado do tema
  final bool isDarkMode;

  // Construtor que exige o 'isDarkMode'
  const IconeCentralMapa({
    super.key,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    // Toda a lógica do Stack que criamos antes agora vive aqui dentro.
    // Ele é totalmente independente e só se preocupa em se desenhar.
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
                // A cor agora usa a propriedade 'isDarkMode' que foi passada.
                // No seu exemplo, a cor era vermelha para ambos os modos.
                // Se quisesse cores diferentes, seria: isDarkMode ? Colors.white : Colors.black
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