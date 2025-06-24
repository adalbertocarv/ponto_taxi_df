import 'package:flutter/material.dart';

class Selecao extends StatelessWidget {
  const Selecao({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecionar Opção'),
      ),
      body: SafeArea(child: Padding(padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Card(),
              Card(),
            ],
          )
        ],
      ),)),
    );
  }
}
