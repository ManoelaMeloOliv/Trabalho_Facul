class Tarefa {
  static const String tableName = 'Tarefa'; 

  final int? id;
  final String titulo;
  final String descricao;
  final String dataPrevista; 
  final bool importante;
  final bool realizada;
  final String categoria; 

  const Tarefa({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.dataPrevista,
    this.importante = false,
    this.realizada = false,
    this.categoria = 'Geral',
  });

  factory Tarefa.fromMap(Map<String, dynamic> map) {
    return Tarefa(
      id: map['id'] as int?,
      titulo: map['titulo'] as String,
      descricao: map['descricao'] as String,
      dataPrevista: map['data_prevista'] as String,
      importante: map['importante'] == 1,   
      realizada: map['realizada'] == 1,
      categoria: map['categoria'] as String? ?? 'Geral',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'descricao': descricao,
      'data_prevista': dataPrevista,
      'importante': importante ? 1 : 0,    
      'realizada': realizada ? 1 : 0,
      'categoria': categoria,
    };
  }

  Tarefa copyWith({
    int? id,
    String? titulo,
    String? descricao,
    String? dataPrevista,
    bool? importante,
    bool? realizada,
    String? categoria,
  }) {
    return Tarefa(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      dataPrevista: dataPrevista ?? this.dataPrevista,
      importante: importante ?? this.importante,
      realizada: realizada ?? this.realizada,
      categoria: categoria ?? this.categoria,
    );
  }

  bool get isAtrasada {
    if (realizada) return false;
    final data = DateTime.tryParse(dataPrevista);
    if (data == null) return false;
    final hoje = DateTime.now();
    return data.isBefore(DateTime(hoje.year, hoje.month, hoje.day));
  }
}