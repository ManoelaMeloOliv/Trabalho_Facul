import 'package:flutter/material.dart';
import 'package:trabalho_facul/models/tarefa.dart';
import 'package:trabalho_facul/provider/tarefaProvider.dart';
import 'package:trabalho_facul/widgets/Tarefa_card.dart';
import 'package:provider/provider.dart';

const Color _roxo = Color(0xFF6D28D9);

class TarefaLista extends StatefulWidget {
  const TarefaLista({super.key});

  @override
  State<TarefaLista> createState() => _TarefaListaState();
}

class _TarefaListaState extends State<TarefaLista>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TarefaProvider>().load();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Tarefa> _lista(TarefaProvider p) {
    switch (_tabController.index) {
      case 1: return p.importantes;
      case 2: return p.pendentes;
      case 3: return p.realizadas;
      case 4: return p.atrasadas;
      default: return p.tarefas;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TarefaProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Tarefas',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(color: _roxo, width: 2),
          ),
          labelColor: _roxo,
          unselectedLabelColor: const Color(0xFF6B7280),
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          unselectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
          onTap: (_) => setState(() {}),
          tabs: const [
            Tab(text: 'Todas'),
            Tab(text: '⭐ Importantes'),
            Tab(text: 'Pendentes'),
            Tab(text: 'Feitas'),
            Tab(text: 'Atrasadas'),
          ],
        ),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator(color: _roxo))
          : _buildLista(provider),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.pushNamed(context, '/form');
          if (context.mounted) context.read<TarefaProvider>().load();
        },
        backgroundColor: _roxo,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Nova tarefa',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        elevation: 2,
      ),
    );
  }

  Widget _buildLista(TarefaProvider provider) {
    final lista = _lista(provider);
    if (lista.isEmpty) {
      return const EmptyState(mensagem: 'Nenhuma tarefa aqui');
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 100),
      itemCount: lista.length,
      itemBuilder: (context, i) {
        final tarefa = lista[i];
        return TarefaCard(
          tarefa: tarefa,
          onTap: () async {
            await Navigator.pushNamed(context, '/detail', arguments: tarefa);
            if (context.mounted) context.read<TarefaProvider>().load();
          },
          onEdit: () async {
            await Navigator.pushNamed(context, '/form', arguments: tarefa);
            if (context.mounted) context.read<TarefaProvider>().load();
          },
          onDelete: () => _deletar(tarefa),
        );
      },
    );
  }

  void _deletar(Tarefa tarefa) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir tarefa?',
            style: TextStyle(fontWeight: FontWeight.w600)),
        content: Text('"${tarefa.titulo}"',
            style: const TextStyle(color: Color(0xFF6B7280))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<TarefaProvider>().delete(tarefa.id!);
            },
            child: const Text('Excluir',
                style: TextStyle(color: Color(0xFFDC2626))),
          ),
        ],
      ),
    );
  }
}
