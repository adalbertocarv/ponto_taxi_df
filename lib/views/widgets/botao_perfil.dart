import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/themes/tema_provider.dart';

class BotaoPerfil extends StatelessWidget {
  const BotaoPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Positioned(
      top: 80,
      left: 16,
      child: FloatingActionButton(

        tooltip: 'Minha Conta', // É bom ter um tooltip descritivo
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: themeProvider.isDarkMode
            ? ThemeProvider.primaryColorDark  // Cor de fundo para tema escuro
            : Colors.white,                   // Cor de fundo para tema claro

        // Use foregroundColor para definir a cor do ícone
        foregroundColor: ThemeProvider.primaryColor,

        onPressed: () {
          print('Botão funcionando!');
        },

        // Deixe o ícone sem tamanho explícito para usar o padrão
        child: Icon(Icons.account_circle_sharp,
          size: 56.0, // Tamanho do botão, não do ícone
        ),
      ),
    );
  }
}
