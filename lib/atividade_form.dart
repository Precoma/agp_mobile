import 'package:flutter/material.dart';
import 'package:agp_mobile/models/atividade.dart';

class AddActivityForm extends StatefulWidget {
  @override
  _AddActivityFormState createState() => _AddActivityFormState();
}

class _AddActivityFormState extends State<AddActivityForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _materiaController = TextEditingController();
  final TextEditingController _dataEntregaController = TextEditingController();
  bool _isLoading = false;

  void _selectDataEntrega(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dataEntregaController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Atividade'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Campo de nome
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    labelText: 'Atividade',
                    labelStyle:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o nome da atividade';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo de descrição
                TextFormField(
                  controller: _descricaoController,
                  decoration: InputDecoration(
                    labelText: 'Descrição',
                    labelStyle:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a descrição';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo de matéria
                TextFormField(
                  controller: _materiaController,
                  decoration: InputDecoration(
                    labelText: 'Matéria',
                    labelStyle:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a matéria';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo de data de entrega
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _dataEntregaController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Data de Entrega',
                          hintText: 'Selecione uma data',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onTap: () => _selectDataEntrega(context),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDataEntrega(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Botão de salvar
                _isLoading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate() &&
                              _dataEntregaController.text.isNotEmpty) {
                            setState(() {
                              _isLoading = true;
                            });
                            final novaAtividade = Atividade(
                              nome: _nomeController.text,
                              descricao: _descricaoController.text,
                              materia: _materiaController.text,
                              feita: false, // "Feita" padrão como false
                              dataEntrega: DateTime.parse(
                                  "${_dataEntregaController.text.split('/')[2]}-${_dataEntregaController.text.split('/')[1]}-${_dataEntregaController.text.split('/')[0]}"),
                            );
                            // Simulando um delay para salvar a atividade
                            Future.delayed(const Duration(seconds: 2), () {
                              setState(() {
                                _isLoading = false;
                              });
                              Navigator.pop(context, novaAtividade);
                            });
                          } else if (_dataEntregaController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Por favor, selecione uma data de entrega')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                        ),
                        child: const Text(
                          'Salvar',
                          style: TextStyle(fontSize: 18, color: Colors.white),
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
