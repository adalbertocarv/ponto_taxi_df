class UsuarioModel {
  final String nome;
  final String email;
  final String telefone;
  final String? fotoPath;

  UsuarioModel({
    required this.nome,
    required this.email,
    required this.telefone,
    this.fotoPath,
  });

  UsuarioModel copyWith({
    String? nome,
    String? email,
    String? telefone,
    String? fotoPath,
  }) {
    return UsuarioModel(
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      fotoPath: fotoPath ?? this.fotoPath,
    );
  }
}
