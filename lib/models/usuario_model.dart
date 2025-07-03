class Usuario {
  final String nomeFuncionario;
  final String matricula;
  final String nomeCargo;
  final String nomeUnidade;
  final String codigoUnidade;
  final String nomeUnidadeSuperior;
  final String codigoUnidadeSuperior;
  String? fotoPath;

  Usuario({
    required this.nomeFuncionario,
    required this.matricula,
    required this.nomeCargo,
    required this.nomeUnidade,
    required this.codigoUnidade,
    required this.nomeUnidadeSuperior,
    required this.codigoUnidadeSuperior,
    this.fotoPath,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      nomeFuncionario: json['nomeFuncionario'],
      matricula: json['matricula'],
      nomeCargo: json['nomeCargo'],
      nomeUnidade: json['nomeUnidade'],
      codigoUnidade: json['codigoUnidade'],
      nomeUnidadeSuperior: json['nomeUnidadeSuperior'],
      codigoUnidadeSuperior: json['codigoUnidadeSuperior'],
    );
  }
}
