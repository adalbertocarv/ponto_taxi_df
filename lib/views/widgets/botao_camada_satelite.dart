import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/themes/tema_provider.dart';

class CamadaSatelite extends StatelessWidget {
  const CamadaSatelite({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Positioned(
        top: 210,
        right: 16,
        child: FloatingActionButton.small(

          tooltip: 'Camada Satélite',
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          backgroundColor: themeProvider.isDarkMode
              ? ThemeProvider.primaryColorDark  // Cor escura para tema escuro
              : ThemeProvider.primaryColor,     // Cor original para tema claro
          onPressed: () {
            print('nao funcionando');
          },
          child: Icon(
            Icons.layers_outlined,
            color: Colors.white,
          ),
        ));
  }
}
