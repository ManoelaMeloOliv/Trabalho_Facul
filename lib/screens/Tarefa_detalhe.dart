import 'package:flutter/material.dart';
import '../provider/tarefaProvider.dart';
import 'package:intl/intl.dart';
import '../models/tarefa.dart';
import 'package:provider/provider.dart';

const Color _roxo = Color(0xFF6D28D9);
const Color _cinzaTexto = Color(0xFF6B7280);
const Color _textoPrincipal = Color(0xFF111827);

class TarefaDetalhe extends StatelessWidget {
  const TarefaDetalhe({super.key});

  @override
  Widget build(BuildContext context) {
    final tarefa = ModalRoute.of(context)!.settings.arguments as Tarefa;

    String dataFormatada = tarefa.dataPrevista;
    try {
      dataFormatada =
          DateFormat('dd/MM/yyyy').format(DateTime.parse(tarefa.dataPrevista));
    } catch (_) {}

    final Color statusCor = tarefa.realizada
        ? const Color(0xFF16A34A)
        : tarefa.isAtrasada
            ? const Color(0xFFDC2626)
            : _roxo;

    final String statusLabel = tarefa.realizada
        ? 'Concluída'
        : tarefa.isAtrasada
            ? 'Atrasada'
            : 'Pendente';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: _cinzaTexto),
            onPressed: () async {
              await Navigator.pushNamed(context, '/form', arguments: tarefa);
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE9FE),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(tarefa.categoria,
                          style: const TextStyle(
                              fontSize: 11, color: _roxo,
                              fontWeight: FontWeight.w500)),
                    ),
                    if (tarefa.importante) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.star_rounded,
                          size: 14, color: Color(0xFFF59E0B)),
                      const SizedBox(width: 2),
                      const Text('Importante',
                          style: TextStyle(
                              fontSize: 11, color: Color(0xFFF59E0B),
                              fontWeight: FontWeight.w500)),
                    ],
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: statusCor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: statusCor.withOpacity(0.3), width: 1),
                      ),
                      child: Text(statusLabel,
                          style: TextStyle(
                              fontSize: 11,
                              color: statusCor,
                              fontWeight: FontWeight.w600)),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  Text(
                    tarefa.titulo,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: _textoPrincipal,
                      decoration:
                          tarefa.realizada ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            _InfoCard(
              icon: Icons.notes_rounded,
              label: 'Descrição',
              valor: tarefa.descricao,
            ),
            const SizedBox(height: 8),
            _InfoCard(
              icon: Icons.calendar_today_outlined,
              label: 'Data prevista',
              valor: dataFormatada,
              cor: tarefa.isAtrasada ? const Color(0xFFDC2626) : null,
            ),
            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await context.read<TarefaProvider>().toggleRealizada(tarefa);
                  if (context.mounted) Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: tarefa.realizada
                      ? const Color(0xFF6B7280)
                      : const Color(0xFF16A34A),
                ),
                icon: Icon(tarefa.realizada
                    ? Icons.undo_rounded
                    : Icons.check_circle_rounded),
                label: Text(tarefa.realizada
                    ? 'Desmarcar como concluída'
                    : 'Marcar como concluída'),
              ),
            ),
            const SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _deletar(context, tarefa),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFDC2626),
                  side: const BorderSide(color: Color(0xFFDC2626)),
                ),
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text('Excluir tarefa'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deletar(BuildContext context, Tarefa tarefa) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir tarefa?',
            style: TextStyle(fontWeight: FontWeight.w600)),
        content: Text(
          'A tarefa "${tarefa.titulo}" será removida permanentemente.',
          style: const TextStyle(color: _cinzaTexto),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await context.read<TarefaProvider>().delete(tarefa.id!);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Excluir',
                style: TextStyle(color: Color(0xFFDC2626))),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String valor;
  final Color? cor;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.valor,
    this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: _roxo),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 11, color: _cinzaTexto)),
                const SizedBox(height: 4),
                Text(valor,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: cor ?? _textoPrincipal)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
