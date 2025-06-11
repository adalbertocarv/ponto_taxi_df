import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/themes/tema_provider.dart';

class BotaoConfirmar extends StatelessWidget {
   BotaoConfirmar({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Positioned(
      bottom: 90,
      left: 36,
      right: 36,

      child: SizedBox(
        height: 56,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: themeProvider.isDarkMode
                ? ThemeProvider.primaryColorDark  // Cor escura para tema escuro
                : ThemeProvider.primaryColor,     // Cor original para tema claro
          ),
          onPressed: () {},
          child: const Text(
            'Cadastrar',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );

  }
}
