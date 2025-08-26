import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/themes/tema_provider.dart';
import '../screens/perfil.dart';

class BotaoPerfil extends StatelessWidget {
  const BotaoPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Positioned(
      top: 104,
      left: 16,
      child: FloatingActionButton(
        heroTag: 'Minha Conta',
        tooltip: 'Minha Conta', // É bom ter um tooltip descritivo se não dá uns bug ae
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: themeProvider.primaryColor,

          onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Perfil())
          );
        },

        //ícone sem tamanho explícito para usar o padrão
        child: Icon(Icons.account_circle_sharp,
          size: 56.0, // Tamanho do botão, não do ícone
        ),
      ),
    );
  }
}
