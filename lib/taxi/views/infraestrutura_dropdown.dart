import 'package:flutter/material.dart';
import '../models/infraestrutura.dart';
import '../services/infra_service.dart';

class InfraestruturaDropdown extends StatefulWidget {
  final String? initialValue; // nome já selecionado (opcional)
  final void Function(Infraestrutura) onChanged;

  const InfraestruturaDropdown({
    super.key,
    this.initialValue,
    required this.onChanged,
  });

  @override
  State<InfraestruturaDropdown> createState() => _InfraestruturaDropdownState();
}

class _InfraestruturaDropdownState extends State<InfraestruturaDropdown> {
  List<Infraestrutura> _items = [];
  Infraestrutura? _selected;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await InfraestruturaService.buscarInfraestruturas();
    setState(() {
      _items = list;

      if (widget.initialValue != null) {
        // Verifica se existe algum item com o nome desejado
        final exists = _items.any(
                (e) => e.nomeInfraestrutura == widget.initialValue);
        if (exists) {
          // Se existir, pega o primeiro (e único) que bate
          _selected =
              _items.firstWhere((e) => e.nomeInfraestrutura == widget.initialValue);
        } else {
          // Caso não exista, fica null
          _selected = null;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _items.isEmpty
        ? const CircularProgressIndicator()
        : DropdownButtonFormField<Infraestrutura>(
      value: _selected,
      decoration: InputDecoration(
        labelText: 'Tipo de Infraestrutura',
        prefixIcon: Icon(Icons.map, color: Theme.of(context).primaryColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: _items
          .map((e) => DropdownMenuItem<Infraestrutura>(
        value: e,
        child: Text(e.nomeInfraestrutura),
      ))
          .toList(),
      onChanged: (Infraestrutura? sel) {
        setState(() {
          _selected = sel;
        });
        if (sel != null) widget.onChanged(sel);
      },
    );
  }
}
