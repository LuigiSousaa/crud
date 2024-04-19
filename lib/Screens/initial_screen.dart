import 'package:flutter/material.dart';
import 'package:projeto/Screens/form_screen.dart';
import 'package:projeto/data/task_dao.dart';

import '../Components/task.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: Icon(Icons.refresh))
        ],
        title: const Text(
          'Tarefas',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 70),
        // future é repsonsavel por pegar os nossos dados que usaremos para construir a tela
        // O builder é reposnável por construir a tela
        // Snapshot é o reponsável pelos dados que chegam do nosso findAll
        child: FutureBuilder<List<Task>>(
          future: TaskDao().findAll(), // Obtém uma lista de tarefas no futuro
          builder: (context, snapshot) {
            // Construtor que será chamado quando o futuro estiver pronto
            List<Task>? items = snapshot.data; // Extrai os dados do snapshot
            // ListView.builder constrói somente o que será exibido na tela. Em um aplicativo onde gerenciamos grandes quantidades de dados, isso é interessante
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      Text('Carregando'),
                    ],
                  ),
                );
              case ConnectionState.waiting:
                return const Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      Text('Carregando'),
                    ],
                  ),
                );
              case ConnectionState.active:
                return const Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      Text('Carregando'),
                    ],
                  ),
                );
              case ConnectionState.done:
                // hasdata pergunta se tem dados
                if (snapshot.hasData && items != null) {
                  if (items.isNotEmpty) {
                    return ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Task tarefa = items[index];
                          return tarefa;
                        });
                  }
                  return const Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 128,
                        ),
                        Text(
                          'Não há nenhuma tarefa',
                          style: TextStyle(fontSize: 32),
                        )
                      ],
                    ),
                  );
                }
                return const Text('Erro ao carregar tarefas');
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (contextNew) => FormScreen(
                        taskContext: context,
                      )),
              // then me da a opção de fazer algo quando voltar da tela que foi direcionado
            ).then((value) => setState(
                () {})); // Neste caso eu reconstruo a página para que ela possa pegar as novas infos adicionadas
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
