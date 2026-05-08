
import 'package:flutter/material.dart';
import 'package:trabalho_facul/provider/tarefaProvider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:trabalho_facul/screens/Tarefa_detalhe.dart';
import 'package:trabalho_facul/screens/Tarefa_form.dart';
import 'package:trabalho_facul/screens/Tarefa_detalhe.dart';
import 'package:provider/provider.dart';
import 'package:trabalho_facul/screens/Tarefa_boas_vindas.dart';
import 'package:trabalho_facul/screens/Tarefa_lista.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TarefaProvider(),
      child: MaterialApp(
        title: 'App de Tarefas',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 92, 66, 238)),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/':       (_) => const TarefaBoasVindas(),
          '/tarefa':  (_) => const TarefaLista(),
          '/form':   (_) => const Tarefaform(),
          '/detalhe': (_) => const TarefaDetalhe(),
        },
      ),
    );
  }
}
