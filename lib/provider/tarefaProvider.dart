import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/tarefa.dart';

class Tarefaprovider extends ChangeNotifier {
  List<tarefa> _tarefa = [];
  Tarefa? proximaTarefa;
  bool isLoading = false;

   List<Tarefa> get Tarefa => _tarefa;
}