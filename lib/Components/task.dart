import 'package:flutter/material.dart';

import '../data/task_dao.dart';
import 'difficulty.dart';

//ignore: must_be_immutable
class Task extends StatefulWidget {
  final String nome;
  final String foto;
  final int dificuldade;

  Task(this.nome, this.foto, this.dificuldade, {super.key});

  int nivel = 1;

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  bool assetOrNetwork() {
    if (widget.foto.contains('http')) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: (widget.nivel == widget.dificuldade * 10)
                    ? (() {
                        widget.nivel = 1;
                        return Colors.green;
                      })()
                    : Colors.blue),
            height: 140,
          ),
          Column(
            children: [
              Container(
                color: null,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white),
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: null,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.black26),
                      width: 80,
                      height: 100,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: assetOrNetwork()
                              ? Image.asset(
                                  widget.foto,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  widget.foto,
                                  fit: BoxFit.cover,
                                )),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: 200,
                            child: Text(
                              widget.nome,
                              style: const TextStyle(fontSize: 22),
                              overflow: TextOverflow.ellipsis,
                            )),
                        Difficulty(
                          difficultyLevel: widget.dificuldade,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onLongPress: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Atenção'),
                                  content: const Text(
                                      'Você tem certeza de que deseja deletar essa tarefa?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        TaskDao().delete(widget.nome);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Sim'),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Não'))
                                  ],
                                );
                              });
                        },
                        onPressed: () {
                          setState(() {
                            widget.nivel++;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Icon(Icons.arrow_drop_up),
                            Text(
                              'Lvl up',
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 200,
                      child: LinearProgressIndicator(
                        color: Colors.white,
                        value: (widget.dificuldade > 0)
                            ? (widget.nivel / widget.dificuldade) / 10
                            : 1,
                      ),
                    ),
                    Text(
                      'Nivel ${widget.nivel}',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
