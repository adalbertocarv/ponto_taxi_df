import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/mapa_controller.dart';

class FormularioTaxi extends StatelessWidget {
  const FormularioTaxi({super.key});

  @override
  Widget build(BuildContext context) {
    final mapaController = context.watch<MapaController>();
    final pontos = mapaController.markers;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário Táxi'),
      ),
      body: SafeArea(child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('localização:$pontos'),
            const SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Endereço', style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
              ],
            ),
            Center(
              child: TextField(

              ),

            )
          ],
        ),
      )),
    );
  }
}
