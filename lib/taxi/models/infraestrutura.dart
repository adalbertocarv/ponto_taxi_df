class Infraestrutura {
  final int idTipoInfraestrutura;
  final String nomeInfraestrutura;
  final bool pontoOficial;

  Infraestrutura({
    required this.idTipoInfraestrutura,
    required this.nomeInfraestrutura,
    required this.pontoOficial,
});

  factory Infraestrutura.fromJson(Map<String, dynamic> json) => Infraestrutura(
    idTipoInfraestrutura: json["id_tipo_infraestrutura"],
    nomeInfraestrutura: json["nome_infraestrutura"],
    pontoOficial: json["ponto_oficial"] ?? false,
  );

  @override
  String toString() => nomeInfraestrutura;
}