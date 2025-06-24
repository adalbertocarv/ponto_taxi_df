import 'package:flutter/material.dart';
import '../models/usuario_model.dart';

class PerfilController extends ChangeNotifier {
  UsuarioModel _usuario = UsuarioModel(
    nome: 'Adalberto Carvalho',
    email: 'adalberto.junior2@semob.df.gov.br',
    telefone: '(61) 99999-9999',
    fotoPath: null,
  );

  UsuarioModel get usuario => _usuario;

  void alterarFoto(String path) {
    _usuario = _usuario.copyWith(fotoPath: path);
    notifyListeners();
  }
}
