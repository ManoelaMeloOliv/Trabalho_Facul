import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trabalho_facul/models/tarefa.dart';
import 'package:trabalho_facul/provider/tarefaProvider.dart';

const Color _roxo = Color(0xFF6D28D9);
const Color _cinzaTexto = Color(0xFF6B7280);
const Color _textoPrincipal = Color(0xFF111827);

class TarefaCard extends StatelessWidget {
  final Tarefa tarefa;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TarefaCard({
    super.key,
    required this.tarefa,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    String dataFormatada = tarefa.dataPrevista;
    try {
      dataFormatada =
          DateFormat('dd/MM/yyyy').format(DateTime.parse(tarefa.dataPrevista));
    } catch (_) {}

    final Color statusCor = tarefa.realizada
        ? const Color(0xFF16A34A)
        : tarefa.isAtrasada
            ? const Color(0xFFDC2626)
            : _cinzaTexto;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox
              GestureDetector(
                onTap: () => context.read<TarefaProvider>().toggleRealizada(tarefa),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 22,
                  height: 22,
                  margin: const EdgeInsets.only(top: 2, right: 12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: tarefa.realizada ? _roxo : Colors.transparent,
                    border: Border.all(
                      color: tarefa.realizada ? _roxo : const Color(0xFFD1D5DB),
                      width: 1.5,
                    ),
                  ),
                  child: tarefa.realizada
                      ? const Icon(Icons.check_rounded,
                          size: 14, color: Colors.white)
                      : null,
                ),
              ),

              // Conteúdo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      if (tarefa.importante) ...[
                        const Icon(Icons.star_rounded,
                            size: 13, color: Color(0xFFF59E0B)),
                        const SizedBox(width: 4),
                      ],
                      Expanded(
                        child: Text(
                          tarefa.titulo,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: tarefa.realizada ? _cinzaTexto : _textoPrincipal,
                            decoration: tarefa.realizada
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert,
                            size: 16, color: _cinzaTexto),
                        color: Colors.white,
                        onSelected: (v) => v == 'edit' ? onEdit() : onDelete(),
                        itemBuilder: (_) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(children: const [
                              Icon(Icons.edit_outlined,
                                  size: 16, color: _cinzaTexto),
                              SizedBox(width: 8),
                              Text('Editar', style: TextStyle(fontSize: 14)),
                            ]),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(children: const [
                              Icon(Icons.delete_outline,
                                  size: 16, color: Color(0xFFDC2626)),
                              SizedBox(width: 8),
                              Text('Excluir',
                                  style: TextStyle(
                                      color: Color(0xFFDC2626), fontSize: 14)),
                            ]),
                          ),
                        ],
                      ),
                    ]),
                    const SizedBox(height: 6),
                    Row(children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDE9FE),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(tarefa.categoria,
                            style: const TextStyle(
                                fontSize: 11, color: _roxo,
                                fontWeight: FontWeight.w500)),
                      ),
                      const Spacer(),
                      Icon(Icons.calendar_today_outlined,
                          size: 11, color: statusCor),
                      const SizedBox(width: 3),
                      Text(dataFormatada,
                          style: TextStyle(
                              fontSize: 11,
                              color: statusCor,
                              fontWeight: tarefa.isAtrasada
                                  ? FontWeight.w600
                                  : FontWeight.w400)),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final String mensagem;
  const EmptyState({super.key, required this.mensagem});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inbox_outlined, size: 40, color: Color(0xFFD1D5DB)),
          const SizedBox(height: 12),
          Text(mensagem,
              style: const TextStyle(
                  color: Color(0xFF9CA3AF), fontSize: 14)),
        ],
      ),
    );
  }
}
