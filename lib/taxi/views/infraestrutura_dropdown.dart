import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/infraestrutura.dart';
import '../providers/themes/tema_provider.dart';
import '../services/infra_service.dart';

class InfraestruturaDropdown extends StatefulWidget {
  final String? initialValue;
  final Function(Infraestrutura) onChanged;

  const InfraestruturaDropdown({
    super.key,
    this.initialValue,
    required this.onChanged,
  });

  @override
  State<InfraestruturaDropdown> createState() => _InfraestruturaDropdownState();
}

class _InfraestruturaDropdownState extends State<InfraestruturaDropdown> {
  List<Infraestrutura> _infraestruturas = [];
  Infraestrutura? _selectedInfraestrutura;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _carregarInfraestruturas();
  }

  Future<void> _carregarInfraestruturas() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final infraestruturas = await InfraestruturaService.buscarInfraestruturas();

      if (mounted) {
        setState(() {
          _infraestruturas = infraestruturas;
          _isLoading = false;

          // Se há um valor inicial, tenta encontrá-lo na lista
          if (widget.initialValue != null && widget.initialValue!.isNotEmpty) {
            _selectedInfraestrutura = _infraestruturas.firstWhere(
                  (infra) => infra.nomeInfraestrutura == widget.initialValue,
              orElse: () => _infraestruturas.first,
            );
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Erro ao carregar infraestruturas';
        });
      }
      print('Erro ao carregar infraestruturas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipo de Infraestrutura',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: themeProvider.isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: themeProvider.isDarkMode
                  ? Colors.grey.shade700
                  : Colors.grey.shade300,
            ),
          ),
          child: _isLoading
              ? _buildLoadingState(themeProvider)
              : _errorMessage != null
              ? _buildErrorState(themeProvider)
              : _buildDropdown(themeProvider, theme),
        ),
      ],
    );
  }

  Widget _buildLoadingState(ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                themeProvider.primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Carregando infraestruturas...',
            style: TextStyle(
              color: themeProvider.isDarkMode
                  ? Colors.white70
                  : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: themeProvider.isDarkMode
                    ? Colors.white70
                    : Colors.black54,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _carregarInfraestruturas,
            tooltip: 'Tentar novamente',
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(ThemeProvider themeProvider, ThemeData theme) {
    return DropdownButtonFormField<Infraestrutura>(
      value: _selectedInfraestrutura,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.business,
          color: themeProvider.primaryColor,
        ),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintText: 'Selecione o tipo de infraestrutura',
        hintStyle: TextStyle(
          color: themeProvider.isDarkMode
              ? Colors.white54
              : Colors.black45,
        ),
      ),
      dropdownColor: theme.cardTheme.color,
      style: TextStyle(
        color: themeProvider.isDarkMode ? Colors.white : Colors.black87,
        fontSize: 14,
      ),
      icon: Icon(
        Icons.arrow_drop_down,
        color: themeProvider.isDarkMode ? Colors.white70 : Colors.black54,
      ),
      isExpanded: true,
      items: _infraestruturas.map((infraestrutura) {
        return DropdownMenuItem<Infraestrutura>(
          value: infraestrutura,
          child: Row(
            children: [
              if (infraestrutura.pontoOficial) ...[
                Icon(
                  Icons.verified,
                  size: 16,
                  color: themeProvider.primaryColor,
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  infraestrutura.nomeInfraestrutura,
                  style: TextStyle(
                    color: themeProvider.isDarkMode
                        ? Colors.white
                        : Colors.black87,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (Infraestrutura? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedInfraestrutura = newValue;
          });
          widget.onChanged(newValue);
        }
      },
      validator: (value) {
        if (value == null) {
          return 'Selecione uma infraestrutura';
        }
        return null;
      },
    );
  }
}