import 'package:flutter/material.dart';
import 'package:trabalho_facul/models/tarefa.dart';
import '../database/database.dart';

class TarefaProvider extends ChangeNotifier {
  List<Tarefa> _tarefa = [];
  Tarefa? proximaTarefa;
  bool isLoading = false;

  List<Tarefa> get tarefas => _tarefa;

  List<Tarefa> get importantes => _tarefa.where((t) => t.importante).toList();
  List<Tarefa> get pendentes   => _tarefa.where((t) => !t.realizada).toList();
  List<Tarefa> get realizadas  => _tarefa.where((t) => t.realizada).toList();
  List<Tarefa> get atrasadas   => _tarefa.where((t) => t.isAtrasada).toList();

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    final rows = await DBUtil.list(Tarefa.tableName);
    _tarefa = rows.map(Tarefa.fromMap).toList();
    proximaTarefa = await DBUtil.getProxima();
    isLoading = false;
    notifyListeners();
  }

  Future<void> add(Tarefa tarefa) async {
    final id = await DBUtil.insert(tarefa);
    _tarefa.add(tarefa.copyWith(id: id));
    proximaTarefa = await DBUtil.getProxima();
    notifyListeners();
  }

  Future<void> update(Tarefa tarefa) async {
    await DBUtil.update(tarefa);
    final i = _tarefa.indexWhere((t) => t.id == tarefa.id);
    if (i != -1) _tarefa[i] = tarefa;
    proximaTarefa = await DBUtil.getProxima();
    notifyListeners();
  }

  Future<void> delete(int id) async {
    await DBUtil.delete(Tarefa.tableName, id); 
    _tarefa.removeWhere((t) => t.id == id);
    proximaTarefa = await DBUtil.getProxima();
    notifyListeners();
  }

  Future<void> toggleRealizada(Tarefa tarefa) async {
    await update(tarefa.copyWith(realizada: !tarefa.realizada));
  }
}
