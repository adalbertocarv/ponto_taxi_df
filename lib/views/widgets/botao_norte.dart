import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/themes/tema_provider.dart';

class BotaoNorte extends StatelessWidget {
  const BotaoNorte({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Positioned(
        top: 160,
        right: 16,
        child: FloatingActionButton.small(

          tooltip: '',
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          backgroundColor: themeProvider.isDarkMode
              ? ThemeProvider.primaryColorDark  // Cor escura para tema escuro
              : ThemeProvider.primaryColor,     // Cor original para tema claro
          onPressed: () {
            print('nao funcionando');
          },
          child: Icon(
            Icons.explore_outlined,
            color: Colors.white,
          ),
        ));
  }
}
