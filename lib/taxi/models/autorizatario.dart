class Autorizatario {
  final String nome;
  final int numAutorizacao;

  Autorizatario({required this.nome, required this.numAutorizacao});

  factory Autorizatario.fromJson(Map<String, dynamic> json) {
    return Autorizatario(
      nome: json['nome'] ?? '',
      numAutorizacao: json['numAutorizacao'] ?? 0,
    );
  }

  @override
  String toString() {
    return "$nome - Num $numAutorizacao";
  }
}
