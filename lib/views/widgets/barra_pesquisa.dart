import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/modo_app_controller.dart';

class BarraPesquisa extends StatefulWidget {
  final Function(String)? onSearch;
  final VoidCallback? onTap;
  final String hintText;
  final bool readOnly;

  const BarraPesquisa({
    super.key,
    this.onSearch,
    this.onTap,
    this.hintText = 'Pesquisar ponto de Táxi/STIP',
    this.readOnly = false,
  });

  @override
  State<BarraPesquisa> createState() => _BarraPesquisaState();
}

class _BarraPesquisaState extends State<BarraPesquisa> {
  final TextEditingController _controller = TextEditingController();
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _showClearButton = _controller.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final modo = context.watch<ModoAppController>();

    if (modo.isCadastro) return const SizedBox.shrink();

    return Positioned(
      top: 45,
      left: 16,
      right: 16,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _controller,
          onChanged: widget.onSearch,
          onTap: widget.onTap,
          readOnly: widget.readOnly,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.grey[600]),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey[600],
            ),
            suffixIcon: _showClearButton
                ? IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.grey[600],
              ),
              onPressed: () {
                _controller.clear();
                widget.onSearch?.call('');
              },
            )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ),
    );
  }
}