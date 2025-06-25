import 'package:flutter/material.dart';

class Sobre extends StatelessWidget {
  const Sobre({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sobre o Aplicativo',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),),
          const SizedBox(height: 24,),
          
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('O Ponto Certo é um aplicativo desenvolvido para auxiliar a Secretaria de Transporte e Mobilidade (SEMOB/SUTER) no mapeamento e cadastro de pontos de parada de ônibus no Distrito Federal. Esta ferramenta permite o registro detalhado de informações sobre cada ponto de parada, facilitando o planejamento e a manutenção do sistema de transporte público.',
                // style: Theme.of(context).textTheme.titleLarge?.copyWith(
                //   fontWeight: FontWeight.w600,
                // ),
                )
              ],
            ),),
          )
        ],
      ),
      ),
      ),
    );
  }
}
