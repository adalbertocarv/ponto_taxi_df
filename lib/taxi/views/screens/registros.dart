import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ponto_taxi_df/taxi/providers/themes/tema_provider.dart';
import 'package:provider/provider.dart';
import '../../controllers/modo_app_controller.dart';
import '../../data/app_database.dart';
import '../widgets/notificacoes.dart';

class Registros extends StatefulWidget {
  const Registros({super.key});

  @override
  State<Registros> createState() => _RegistrosState();
}

class _RegistrosState extends State<Registros> {
  final _db = AppDatabase();
  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final modoApp = context.read<ModoAppController>();
    final themeProvider = context.read<ThemeProvider>();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment, color: themeProvider.primaryColor, size: 26),
                  const SizedBox(width: 20),
                  Text(
                    'R E G I S T R O S',
                    style: TextStyle(
                      fontSize: 24,
                      color: themeProvider.primaryColor,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Stack(
                  children: [
                    FutureBuilder<List<Ponto>>(
                      future: _db.getAllPontos(),
                      builder: (_, snap) {
                        if (snap.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (!snap.hasData || snap.data!.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Nenhum registro hoje',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.w800,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(24.0),
                                  child: Text(
                                    'Pontos cadastrados ou em fila de envio estarão aqui disponíveis para visualização',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.w100,
                                    ),
                                  ),
                                ),
                                modoApp.isCadastro
                                    ? Image.asset('assets/images/bus_stop_azul.webp')
                                    : Image.asset('assets/images/bus_stop_verde.webp'),
                              ],
                            ),
                          );
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
                    const Notificacao(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
class _PontoCard extends StatelessWidget {
  final Ponto ponto;
  final VoidCallback onDeleted;
  final _db = AppDatabase();

  _PontoCard({required this.ponto, required this.onDeleted});

  @override
  Widget build(BuildContext context) {

    final modo = context.watch<ModoAppController>();

    final img = ponto.imagens.isNotEmpty ? ponto.imagens.first : null;
    // só aparece no modo Cadastro
    if (modo.isVistoria) return const SizedBox.shrink();
    return Column(
      children: [
        Card(
          elevation: 6,
          color: Colors.orange[400]!.withValues(alpha: 0.5),
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
//======================CARDS===================================================
//
//   Widget cardsVistoria() => Column(
//     children: [
//       Card(
//         elevation: 6,
//         color: Colors.orange[400]!.withValues(alpha: 0.5),
//         margin: const EdgeInsets.symmetric(vertical: 6),
//         child: Row(
//           children: [
//             Expanded(
//               child: ListTile(
//                 leading: img != null
//                     ? ClipRRect(
//                   borderRadius: BorderRadius.circular(6),
//                   child: Image.file(File(img),
//                       width: 60, height: 60, fit: BoxFit.cover),
//                 )
//                     : const Icon(Icons.location_on, size: 40),
//                 title: Text(ponto.endereco),
//                 subtitle: Text(
//                   '${ponto.numVagas} vagas • ${ponto.classificacaoEstrutura}\n'
//                       'Tel.: ${ponto.telefones.join(', ')}'' \n• LatLong ${ponto.latitude}, ${ponto.longitude}',
//                 ),
//                 isThreeLine: true,
//               ),
//             ),
//             IconButton(
//               icon: const Icon(Icons.delete, color: Colors.red),
//               tooltip: 'Excluir item',
//               onPressed: () => _confirmarExclusao(context),
//             ),
// //           IconButton(onPressed: () async {
// // final pontos = await _db.getAllPontos();   // ← chama () e await
// // for (final p in pontos) {
// // debugPrint(p.toString());                // ou print
// // }
// // },
// //  icon: Icon(Icons.receipt, color: Colors.white)
// //           )
//           ],
//         ),
//       ),
//     ],
//   );
//
//   Widget cardsCadastro() => Column(
//     children: [
//       Card(
//         elevation: 6,
//         color: Colors.orange[400]!.withValues(alpha: 0.5),
//         margin: const EdgeInsets.symmetric(vertical: 6),
//         child: Row(
//           children: [
//             Expanded(
//               child: ListTile(
//                 leading: img != null
//                     ? ClipRRect(
//                   borderRadius: BorderRadius.circular(6),
//                   child: Image.file(File(img),
//                       width: 60, height: 60, fit: BoxFit.cover),
//                 )
//                     : const Icon(Icons.location_on, size: 40),
//                 title: Text(ponto.endereco),
//                 subtitle: Text(
//                   '${ponto.numVagas} vagas • ${ponto.classificacaoEstrutura}\n'
//                       'Tel.: ${ponto.telefones.join(', ')}'' \n• LatLong ${ponto.latitude}, ${ponto.longitude}',
//                 ),
//                 isThreeLine: true,
//               ),
//             ),
//             IconButton(
//               icon: const Icon(Icons.delete, color: Colors.red),
//               tooltip: 'Excluir item',
//               onPressed: () => _confirmarExclusao(context),
//             ),
// //           IconButton(onPressed: () async {
// // final pontos = await _db.getAllPontos();   // ← chama () e await
// // for (final p in pontos) {
// // debugPrint(p.toString());                // ou print
// // }
// // },
// //  icon: Icon(Icons.receipt, color: Colors.white)
// //           )
//           ],
//         ),
//       ),
//     ],
//   );

