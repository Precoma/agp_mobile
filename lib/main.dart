import 'package:flutter/material.dart';
import 'package:agp_mobile/models/atividade.dart';
import 'atividade_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AGP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true, // Usando Material 3
        textTheme: TextTheme(
          bodyLarge: TextStyle(
              fontSize: 16, color: Colors.black87), // Usando bodyLarge
          titleLarge: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18), // Usando titleLarge
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  var atividades = <Atividade>[];

  HomePage({super.key}) {
    atividades.add(Atividade(
      nome: "Atividade de Matemática",
      descricao: "Resolver exercícios da página 10 a 20",
      materia: "Matemática",
      feita: false,
      dataEntrega: DateTime(2023, 12, 20),
    ));
    atividades.add(Atividade(
      nome: "Leitura de Livro",
      descricao: "Ler o capítulo 3 do livro de história",
      materia: "História",
      feita: true,
      dataEntrega: DateTime(2023, 11, 25),
    ));
    atividades.add(Atividade(
      nome: "Exercício de Física",
      descricao: "Fazer os exercícios de vetores",
      materia: "Física",
      feita: false,
      dataEntrega: DateTime(2023, 12, 20),
    ));
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<int, bool> _expandedState =
      {}; // Mapeia o índice da atividade para o estado de expansão.

  void _navigateToAddActivity() async {
    final novaAtividade = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddActivityForm()),
    );

    if (novaAtividade != null) {
      setState(() {
        widget.atividades.add(novaAtividade);
        widget.atividades.sort((a, b) =>
            a.dataEntrega.compareTo(b.dataEntrega)); // Ordena as atividades
      });
    }
  }

  // Função para dividir as atividades por data de entrega
  Map<String, List<Atividade>> _dividirAtividadesPorDia() {
    Map<String, List<Atividade>> atividadesPorDia = {};

    for (var atividade in widget.atividades) {
      String chaveDia =
          "${atividade.dataEntrega.day}/${atividade.dataEntrega.month}/${atividade.dataEntrega.year}";

      if (!atividadesPorDia.containsKey(chaveDia)) {
        atividadesPorDia[chaveDia] = [];
      }
      atividadesPorDia[chaveDia]!.add(atividade);
    }

    return atividadesPorDia;
  }

  void _toggleAtividadeFeita(int index) {
    setState(() {
      widget.atividades[index].feita = !widget.atividades[index].feita;
    });
  }

  // Função para deletar uma atividade
  void _deleteActivity(int index) {
    setState(() {
      widget.atividades.removeAt(index);
      _expandedState.remove(index); // Limpar o estado de expansão após exclusão
    });
  }

  @override
  Widget build(BuildContext context) {
    final atividadesPorDia =
        _dividirAtividadesPorDia(); // Divide as atividades por dia

    return Scaffold(
      appBar: AppBar(
        title: const Text("Agenda Pessoal Escolar"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView(
        children: atividadesPorDia.entries.map((entry) {
          String dia = entry.key;
          List<Atividade> atividadesNoDia = entry.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  dia,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ...atividadesNoDia.map((atividade) {
                int index = widget.atividades.indexOf(atividade);
                bool isExpanded = _expandedState[index] ??
                    false; // Verifica o estado de expansão.

                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                  elevation: 4,
                  child: ExpansionTile(
                    onExpansionChanged: (expanded) {
                      setState(() {
                        _expandedState[index] =
                            expanded; // Atualiza o estado de expansão.
                      });
                    },
                    leading: Checkbox(
                      value: atividade.feita,
                      onChanged: (bool? value) {
                        setState(() {
                          atividade.feita = value ?? false;
                        });
                      },
                    ),
                    title: Text(atividade.nome),
                    trailing: isExpanded
                        ? IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteActivity(index);
                            },
                          )
                        : null, // Exibe o ícone de deletar apenas quando expandido
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Descrição: ${atividade.descricao}"),
                            const SizedBox(height: 5),
                            Text("Matéria: ${atividade.materia}"),
                            const SizedBox(height: 5),
                            Text(
                              "Data de Entrega: ${atividade.dataEntrega.day}/${atividade.dataEntrega.month}/${atividade.dataEntrega.year}",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddActivity,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
