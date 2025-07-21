import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/mapa_controller.dart';
import '../../controllers/modo_app_controller.dart';
import '../../data/app_database.dart';

class Registros extends StatefulWidget {
  const Registros({super.key});

  @override
  State<Registros> createState() => _RegistrosState();
}

class _RegistrosState extends State<Registros> {
  final _db = AppDatabase();                 // singleton
  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final modoApp = context.read<ModoAppController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'R E G I S T R O S',
        style: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w800,
        ),),
      ),
      body: FutureBuilder<List<Ponto>>(
        future: _db.getAllPontos(),          // ← busca tudo do banco
        builder: (_, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snap.hasData || snap.data!.isEmpty) {
            return Center(child: Column(
             // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 120,),
                const Text(
                  'Nenhum registro hoje',
                  style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.italic
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text('Paradas cadastradas ou em fila de envio estarão aqui disponíveis para visualização',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.w100),),
                ),
                modoApp.isCadastro
                ? Image.asset('assets/images/bus_stop_azul.webp')
          : Image.asset('assets/images/bus_stop_verde.webp')
              ],
            ));
          }

          final pontos = snap.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: pontos.length,
            itemBuilder: (_, i) => _PontoCard(
              ponto: pontos[i],
              onDeleted: _refresh,
            ),
          );
        },
      ),
    );
  }
}
class _PontoCard extends StatelessWidget {
  final Ponto ponto;
  final VoidCallback onDeleted;
  final _db = AppDatabase();

  _PontoCard({required this.ponto, required this.onDeleted, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapaController = context.watch<MapaController>();

    final modo = context.watch<ModoAppController>();

    final img = ponto.imagens.isNotEmpty ? ponto.imagens.first : null;
    // só aparece no modo Cadastro
    if (!modo.isCadastro) return const SizedBox.shrink();
    var pontos = _db.getAllPontos;
    return Column(
      children: [
        Card(
          elevation: 6,
          color: Colors.orange[400]!.withOpacity(0.5),
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Expanded(
                child: ListTile(
                  leading: img != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.file(File(img),
                        width: 60, height: 60, fit: BoxFit.cover),
                  )
                      : const Icon(Icons.location_on, size: 40),
                  title: Text(ponto.endereco),
                  subtitle: Text(
                    '${ponto.numVagas} vagas • ${ponto.classificacaoEstrutura}\n'
                        'Tel.: ${ponto.telefones.join(', ')}'' \n• LatLong ${ponto.latitude}, ${ponto.longitude}',
                  ),
                  isThreeLine: true,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                tooltip: 'Excluir item',
                onPressed: () => _confirmarExclusao(context),
              ),
    //           IconButton(onPressed: () async {
    // final pontos = await _db.getAllPontos();   // ← chama () e await
    // for (final p in pontos) {
    // debugPrint(p.toString());                // ou print
    // }
    // },
    //  icon: Icon(Icons.receipt, color: Colors.white)
    //           )
            ],
          ),
        ),
      ],
    );


  }

  Future<void> _confirmarExclusao(BuildContext context) async {
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir registro?'),
        content: const Text('Esta ação não poderá ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(_, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(_, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await _db.deletePonto(ponto.id!);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro excluído')),
        );
      }
      onDeleted(); // avisa o pai para atualizar a lista
    }
  }
}

