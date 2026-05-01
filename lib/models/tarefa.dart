class Task {
  int? id;
  String titulo;
  String descricao;
  String data;
  bool importante;
  bool realizada;
  String prioridade;

  Task({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.data,
    required this.importante,
    required this.realizada,
    required this.prioridade,
  });
}