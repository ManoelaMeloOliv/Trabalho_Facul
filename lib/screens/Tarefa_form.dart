import 'package:flutter/material.dart';
import 'package:trabalho_facul/models/tarefa.dart';
import 'package:intl/intl.dart';
import 'package:trabalho_facul/provider/tarefaProvider.dart';
import 'package:provider/provider.dart';

const Color _roxo = Color(0xFF6D28D9);
const Color _cinzaTexto = Color(0xFF6B7280);
const Color _textoPrincipal = Color(0xFF111827);

class Tarefaform extends StatefulWidget {
  const Tarefaform({super.key});

  @override
  State<Tarefaform> createState() => _TarefaformState();
}

class _TarefaformState extends State<Tarefaform> {
  final _formKey = GlobalKey<FormState>();
  final _tituloCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  DateTime? _data;
  bool _importante = false;
  String _categoria = 'Geral';
  Tarefa? _editando;

  final _categorias = ['Geral', 'Trabalho', 'Estudo', 'Pessoal', 'Saúde'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tarefa = ModalRoute.of(context)?.settings.arguments;
      if (tarefa is Tarefa) {
        _editando = tarefa;
        _tituloCtrl.text = tarefa.titulo;
        _descCtrl.text = tarefa.descricao;
        _importante = tarefa.importante;
        _categoria = tarefa.categoria;
        try { _data = DateTime.parse(tarefa.dataPrevista); } catch (_) {}
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickData() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _data ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: _roxo,
            onPrimary: Colors.white,
            onSurface: _textoPrincipal,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _data = picked);
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_data == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Selecione uma data'),
          backgroundColor: _roxo,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    final dataStr = _data!.toIso8601String().substring(0, 10);
    final provider = context.read<TarefaProvider>();

    if (_editando != null) {
      await provider.update(_editando!.copyWith(
        titulo: _tituloCtrl.text.trim(),
        descricao: _descCtrl.text.trim(),
        dataPrevista: dataStr,
        importante: _importante,
        categoria: _categoria,
      ));
    } else {
      await provider.add(Tarefa(
        titulo: _tituloCtrl.text.trim(),
        descricao: _descCtrl.text.trim(),
        dataPrevista: dataStr,
        importante: _importante,
        categoria: _categoria,
      ));
    }

    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdicao = _editando != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdicao ? 'Editar tarefa' : 'Nova tarefa',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
        actions: [
          TextButton(
            onPressed: _salvar,
            child: const Text('Salvar',
                style: TextStyle(
                    color: _roxo,
                    fontWeight: FontWeight.w600,
                    fontSize: 15)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('Título'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _tituloCtrl,
                decoration: const InputDecoration(
                  hintText: 'Ex: Estudar Flutter',
                  hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                ),
                validator: (v) =>
                    (v == null || v.trim().length < 3) ? 'Mínimo 3 caracteres' : null,
              ),
              const SizedBox(height: 16),

              _label('Descrição'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Descreva sua tarefa...',
                  hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 16),

              _label('Data prevista'),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: _pickData,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _data != null ? _roxo : const Color(0xFFE5E7EB),
                      width: _data != null ? 1.5 : 1,
                    ),
                  ),
                  child: Row(children: [
                    Icon(Icons.calendar_today_outlined,
                        color: _data != null ? _roxo : _cinzaTexto, size: 18),
                    const SizedBox(width: 10),
                    Text(
                      _data == null
                          ? 'Selecionar data'
                          : DateFormat('dd/MM/yyyy').format(_data!),
                      style: TextStyle(
                        color: _data == null ? const Color(0xFF9CA3AF) : _textoPrincipal,
                        fontSize: 14,
                      ),
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: 16),

              _label('Categoria'),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _categoria,
                dropdownColor: Colors.white,
                decoration: const InputDecoration(),
                items: _categorias
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _categoria = v!),
              ),
              const SizedBox(height: 16),

              // Importante
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: SwitchListTile(
                  title: const Text('Marcar como importante',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500,
                          color: _textoPrincipal)),
                  value: _importante,
                  onChanged: (v) => setState(() => _importante = v),
                  activeThumbColor: _roxo,
                  secondary: Icon(
                    _importante ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: _importante ? const Color(0xFFF59E0B) : _cinzaTexto,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _salvar,
                  icon: Icon(isEdicao
                      ? Icons.update_rounded
                      : Icons.add_task_rounded),
                  label: Text(isEdicao ? 'Atualizar tarefa' : 'Criar tarefa'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: const TextStyle(
            fontSize: 13, fontWeight: FontWeight.w500, color: _cinzaTexto),
      );
}
