import 'package:flutter/material.dart';
import 'package:trabalho_facul/provider/tarefaProvider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trabalho_facul/models/tarefa.dart';

const Color _roxo = Color(0xFF6D28D9);
const Color _roxoClaro = Color(0xFFEDE9FE);
const Color _cinzaTexto = Color(0xFF6B7280);
const Color _textoPrincipal = Color(0xFF111827);

class TarefaBoasVindas extends StatefulWidget {
  const TarefaBoasVindas({super.key});

  @override
  State<TarefaBoasVindas> createState() => _TarefaBoasVindasState();
}

class _TarefaBoasVindasState extends State<TarefaBoasVindas> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TarefaProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TarefaProvider>();
    final proxima = provider.proximaTarefa;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),

              const Text(
                'Olá! 👋',
                style: TextStyle(fontSize: 14, color: _cinzaTexto),
              ),
              const SizedBox(height: 4),
              const Text(
                'Suas tarefas',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: _textoPrincipal,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 20),

              // Próxima tarefa
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: provider.isLoading
                    ? const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: _roxo, strokeWidth: 2),
                        ),
                      )
                    : proxima == null
                        ? Row(children: const [
                            Icon(Icons.celebration_outlined,
                                color: _cinzaTexto, size: 20),
                            SizedBox(width: 10),
                            Text(
                              'Nenhuma tarefa pendente!',
                              style: TextStyle(color: _cinzaTexto, fontSize: 14),
                            ),
                          ])
                        : _ProximaTarefa(tarefa: proxima),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/tasks'),
                  child: const Text('Ver tarefas'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pushNamed(context, '/form'),
                  child: const Text('Nova tarefa'),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResumoCard extends StatelessWidget {
  final TarefaProvider provider;
  const _ResumoCard({required this.provider});

  @override
  Widget build(BuildContext context) {
    final total = provider.tarefas.length;
    final realizadas = provider.realizadas.length;
    final pendentes = provider.pendentes.length;
    final atrasadas = provider.atrasadas.length;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: _roxoClaro,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Stat(valor: total.toString(), label: 'Total'),
          _Sep(),
          _Stat(valor: pendentes.toString(), label: 'Pendentes', cor: _roxo),
          _Sep(),
          _Stat(valor: realizadas.toString(), label: 'Feitas',
              cor: const Color(0xFF16A34A)),
          if (atrasadas > 0) ...[
            _Sep(),
            _Stat(valor: atrasadas.toString(), label: 'Atrasadas',
                cor: const Color(0xFFDC2626)),
          ],
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String valor;
  final String label;
  final Color? cor;
  const _Stat({required this.valor, required this.label, this.cor});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(valor,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: cor ?? _textoPrincipal,
          )),
      const SizedBox(height: 2),
      Text(label,
          style: const TextStyle(fontSize: 11, color: _cinzaTexto)),
    ]);
  }
}

class _Sep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 28, color: const Color(0xFFD8D4FE));
  }
}

class _ProximaTarefa extends StatelessWidget {
  final Tarefa tarefa;
  const _ProximaTarefa({required this.tarefa});

  @override
  Widget build(BuildContext context) {
    String dataLabel = tarefa.dataPrevista;
    try {
      final d = DateTime.parse(tarefa.dataPrevista);
      final diff = d.difference(DateTime.now()).inDays;
      final formatada = DateFormat('dd/MM/yyyy').format(d);
      dataLabel = diff == 0 ? 'Hoje · $formatada' : 'Em $diff dias · $formatada';
    } catch (_) {}

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Próxima a vencer',
          style: TextStyle(fontSize: 11, color: _cinzaTexto)),
      const SizedBox(height: 6),
      Text(tarefa.titulo,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _textoPrincipal,
          )),
      const SizedBox(height: 4),
      Row(children: [
        const Icon(Icons.calendar_today_outlined, size: 12, color: _roxo),
        const SizedBox(width: 4),
        Text(dataLabel,
            style: const TextStyle(fontSize: 12, color: _cinzaTexto)),
      ]),
    ]);
  }
}
