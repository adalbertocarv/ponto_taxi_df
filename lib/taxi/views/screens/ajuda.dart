import 'package:flutter/material.dart';

class Ajuda extends StatelessWidget {
  const Ajuda({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajuda'),
      ),
      body: SafeArea(child: Column(
        children: [
          Text('Aqui vai ser a ajuda')
        ],
      )),
    );
  }
}
