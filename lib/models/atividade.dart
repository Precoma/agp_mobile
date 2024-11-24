class Atividade {
  int? id;
  String nome;
  String descricao;
  String materia;
  bool feita;
  DateTime dataEntrega;

  // Construtor
  Atividade({
    this.id,
    required this.nome,
    required this.descricao,
    required this.materia,
    required this.feita,
    required this.dataEntrega,
  });

  // Converter para JSON para armazenar no banco de dados
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'materia': materia,
      'feita': feita ? 1 : 0, // Converte o valor booleano para inteiro
      'dataEntrega':
          dataEntrega.toIso8601String(), // Formato de data para string
    };
  }

  // Criar uma atividade a partir de um JSON
  Atividade.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nome = json['nome'],
        descricao = json['descricao'],
        materia = json['materia'],
        feita = json['feita'] == 1, // Converte de volta para booleano
        dataEntrega = DateTime.parse(json['dataEntrega']);
}
