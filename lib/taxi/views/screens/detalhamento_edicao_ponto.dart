import 'package:flutter/material.dart';

class DetalhamentoEdicaoPonto extends StatefulWidget {
  const DetalhamentoEdicaoPonto({super.key});

  @override
  State<DetalhamentoEdicaoPonto> createState() =>
      _DetalhamentoEdicaoPontoState();
}

class _DetalhamentoEdicaoPontoState extends State<DetalhamentoEdicaoPonto> {
  // Chave global para o formulário
  final _formKey = GlobalKey<FormState>();

  // Controladores de texto para capturar os valores dos campos
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _numVagasController = TextEditingController();

  // Lista de opções para o Dropdown
  final List<String> _tiposInfraestrutura = [
    'Residencial',
    'Comercial',
    'Industrial',
    'Público/Governamental',
    'Misto',
  ];

  // 2. Variável de estado para armazenar o valor selecionado do Dropdown
  String? _selectedInfraestrutura; // Inicialmente nulo ou com um valor padrão, se houver

  @override
  void initState() {
    super.initState();
    // Definindo um valor padrão ao iniciar, se necessário (ex: a primeira opção da lista)
    _selectedInfraestrutura = _tiposInfraestrutura[1]; // Exemplo: 'Comercial'
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          flexibleSpace: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, color: Colors.white),
              const SizedBox(width: 12),
              Center(
                child: Text(
                  'Informações do Ponto',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          centerTitle: true,
          automaticallyImplyLeading: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // 1. Campo Endereço (Mantido)
                TextFormField(
                  controller: _enderecoController,
                  decoration: const InputDecoration(
                    labelText: 'Corrija o endereço se necessário',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, preencha o Endereço';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // 2. Campo Tipo Infraestrutura (SUBSTITUÍDO POR DropdownButtonFormField)
                DropdownButtonFormField<String>(
                  value: _selectedInfraestrutura,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de infraestrutura',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.house_outlined),
                  ),
                  hint: const Text('Selecione o tipo de infraestrutura'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, selecione o tipo de infraestrutura';
                    }
                    return null;
                  },
                  isExpanded:
                      true, // Garante que o dropdown ocupe a largura total
                  items: _tiposInfraestrutura.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedInfraestrutura = newValue;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // 3. Campo Vagas (Mantido como TextFormField)
                TextFormField(
                  controller: _numVagasController,
                  decoration: const InputDecoration(
                    labelText: 'Quantidade de vagas',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.directions_car_filled),
                  ),
                  keyboardType: TextInputType.number, // Ajuda a digitar números
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, preencha a quantidade de vagas';
                    }
                    // Validação adicional para garantir que é um número
                    if (int.tryParse(value) == null) {
                      return 'Deve ser um número inteiro';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Botão de Salvar
                ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Salvando informações do ponto...')),
                      );
                      // Lógica de salvamento aqui
                      print('Endereço: ${_enderecoController.text}');
                      // O valor do Dropdown é acessado pela variável de estado:
                      print('Tipo de Infraestrutura: $_selectedInfraestrutura');
                      print('N° de Vagas: ${_numVagasController.text}');
                    }
                  },
                  icon: const Icon(Icons.save),
                  label: const Text(
                    'Salvar Alterações',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
