import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/themes/tema_provider.dart';

class CamadaSatelite extends StatelessWidget {
  final bool ativo;
  final VoidCallback onToggle;

  const CamadaSatelite({super.key, required this.ativo, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Positioned(
      top: 210,
      right: 16,
      child: FloatingActionButton.small(
        tooltip: 'Camada Satélite',
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: themeProvider.isDarkMode
            ? ThemeProvider.primaryColorDark
            : ThemeProvider.primaryColor,
        onPressed: onToggle,
        child: Icon(
          ativo ? Icons.satellite_alt_outlined : Icons.layers_outlined,
          color: Colors.white,
        ),
      ),
    );
  }
}
