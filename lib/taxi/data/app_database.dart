import 'dart:async';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// -------------- MODELS -----------------------------------------------------

class Ponto {
  Ponto({
    this.id,
    required this.latitude,
    required this.longitude,
    required this.endereco,
    required this.pontoOficial,
    required this.classificacaoEstrutura,
    required this.numVagas,
    required this.temAbrigo,
    required this.temSinalizacao,
    required this.temEnergia,
    required this.temAgua,
    this.observacoes,
    required this.telefones,
    required this.imagens,
  });

  int? id;
  final double latitude;
  final double longitude;
  final String endereco;
  final bool pontoOficial;
  final String classificacaoEstrutura;
  final int numVagas;
  final bool temAbrigo;
  final bool temSinalizacao;
  final bool temEnergia;
  final bool temAgua;
  final String? observacoes;
  final List<String> telefones;
  final List<String> imagens;

  Map<String, dynamic> toMap() => {
    'id': id,
    'latitude': latitude,
    'longitude': longitude,
    'endereco': endereco,
    'ponto_oficial': pontoOficial ? 1 : 0,
    'classificacao_estrutura': classificacaoEstrutura,
    'num_vagas': numVagas,
    'tem_abrigo': temAbrigo ? 1 : 0,
    'tem_sinalizacao': temSinalizacao ? 1 : 0,
    'tem_energia': temEnergia ? 1 : 0,
    'tem_agua': temAgua ? 1 : 0,
    'observacoes': observacoes,
  };

  factory Ponto.fromRow(
      Map<String, dynamic> row,
      List<String> tels,
      List<String> imgs,
      ) =>
      Ponto(
        id: row['id'] as int,
        latitude: row['latitude'] as double,
        longitude: row['longitude'] as double,
        endereco: row['endereco'] as String,
        pontoOficial: (row['ponto_oficial'] as int) == 1,
        classificacaoEstrutura: row['classificacao_estrutura'] as String,
        numVagas: row['num_vagas'] as int,
        temAbrigo: (row['tem_abrigo'] as int) == 1,
        temSinalizacao: (row['tem_sinalizacao'] as int) == 1,
        temEnergia: (row['tem_energia'] as int) == 1,
        temAgua: (row['tem_agua'] as int) == 1,
        observacoes: row['observacoes'] as String?,
        telefones: tels,
        imagens: imgs,
      );

  @override
  String toString() => '''
Ponto #$id
  lat/lon : $latitude , $longitude
  endereço: $endereco
  vagas   : $numVagas
  oficial : $pontoOficial
  abrigo  : $temAbrigo  | sinalização: $temSinalizacao
  energia : $temEnergia | água: $temAgua
  telefones: $telefones
  imagens  : $imagens
  obs      : $observacoes
''';

}

/// -------------- DATABASE SINGLETON ----------------------------------------

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._();
  static Database? _db;
  AppDatabase._();
  factory AppDatabase() => _instance;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, 'pontos_taxi.db');

    return openDatabase(
      path,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE pontos (
            id                      INTEGER PRIMARY KEY AUTOINCREMENT,
            latitude                REAL    NOT NULL,
            longitude               REAL    NOT NULL,
            endereco                TEXT    NOT NULL,
            ponto_oficial           INTEGER NOT NULL,
            classificacao_estrutura TEXT    NOT NULL,
            num_vagas               INTEGER NOT NULL,
            tem_abrigo              INTEGER NOT NULL,
            tem_sinalizacao         INTEGER NOT NULL,
            tem_energia             INTEGER NOT NULL,
            tem_agua                INTEGER NOT NULL,
            observacoes             TEXT
          );
        ''');

        await db.execute('''
          CREATE TABLE telefones (
            id       INTEGER PRIMARY KEY AUTOINCREMENT,
            ponto_id INTEGER NOT NULL,
            numero   TEXT    NOT NULL,
            FOREIGN KEY (ponto_id) REFERENCES pontos(id) ON DELETE CASCADE
          );
        ''');

        await db.execute('''
          CREATE TABLE imagens (
            id       INTEGER PRIMARY KEY AUTOINCREMENT,
            ponto_id INTEGER NOT NULL,
            path     TEXT    NOT NULL,
            FOREIGN KEY (ponto_id) REFERENCES pontos(id) ON DELETE CASCADE
          );
        ''');
      },
    );
  }

  /// ----------------- CRUD --------------------------------------------------

  Future<int> insertPonto(Ponto ponto) async {
    final db = await database;
    return db.transaction((txn) async {
      final pontoId = await txn.insert('pontos', ponto.toMap());

      for (final tel in ponto.telefones) {
        await txn.insert('telefones', {
          'ponto_id': pontoId,
          'numero': tel,
        });
      }

      for (final img in ponto.imagens) {
        await txn.insert('imagens', {
          'ponto_id': pontoId,
          'path': img,
        });
      }

      return pontoId;
    });
  }

  Future<List<Ponto>> getAllPontos() async {
    final db = await database;
    final pontoRows = await db.query('pontos');

    List<Ponto> result = [];

    for (final row in pontoRows) {
      final id = row['id'] as int;

      final telRows = await db.query(
        'telefones',
        where: 'ponto_id = ?',
        whereArgs: [id],
      );
      final imgRows = await db.query(
        'imagens',
        where: 'ponto_id = ?',
        whereArgs: [id],
      );

      result.add(
        Ponto.fromRow(
          row,
          telRows.map((e) => e['numero'] as String).toList(),
          imgRows.map((e) => e['path'] as String).toList(),
        ),
      );
    }
    return result;
  }

  Future<void> deletePonto(int id) async {
    final db = await database;
    await db.delete('pontos', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _db = null;
  }
}
