import 'package:projeto/Components/task.dart';
import 'package:projeto/data/database.dart';
import 'package:sqflite/sqflite.dart';

class TaskDao {
  static const String tableSql = 'CREATE TABLE IF NOT EXISTS $_tablename ('
      '$_name TEXT, '
      '$_difficulty INTEGER, '
      '$_url TEXT,)';

  static const String _tablename = 'taskTable';
  static const String _name = 'name';
  static const String _difficulty = 'difficulty';
  static const String _url = 'url';

  // Assíncronas pois se comunicarão com o banco. E o banco pode demorar a se comunicar com o app (future)
  save(Task tarefa) async {
    print('Acessando save: ');
    final Database bancoDados = await getDatabase();
    // A variável armazenará uma lista de objs, onde nossa referência é o nome
    // Vamos fazer a consulta para empedir a entrada de valores duplicados
    var itemExists = await find(tarefa.nome);
    Map<String, dynamic> taskMap = toMap(tarefa);
    // Avaliando se já existe ou não uma tarefa com aquele detrminado nome
    if (itemExists.isEmpty) {
      print('A tarefa não exitia');
      // Se a variável estiver vazia, significa que não existia uma tarefa com aquele nome.
      // Então inserimos os novos valores e criamos uma nova tarefa
      return await bancoDados.insert(_tablename, taskMap);
    } else {
      print('Essa tarefa já existe');
      // Caso contrário, a tarefa já existe.
      // Então daremos um update na tarefa que tem aquele nome
      return await bancoDados.update(
        _tablename,
        taskMap,
        // A tarefa terá seu nome alterado pelo nome buscado, ou seja, permanecerá com o mesmo
        where: '$_name = ?',
        whereArgs: [tarefa.nome],
      );
    }
  }

  Map<String, dynamic> toMap(Task tarefa) {
    print('Convertendo a lista em mapa');
    Map<String, dynamic> mapaTarfeas = Map();
    mapaTarfeas[_name] = tarefa.nome;
    mapaTarfeas[_difficulty] = tarefa.dificuldade;
    mapaTarfeas[_url] = tarefa.foto;
    print('Mapa de  tarefas $mapaTarfeas');
    return mapaTarfeas;
  }

  Future<List<Task>> find(String nomeTarefa) async {
    print('Acessando find: ');
    final Database bancoDados = await getDatabase();
    final List<Map<String, dynamic>> result = await bancoDados.query(
      // Nome do banco
      _tablename,
      // Onde ficam os nome (ou o parâmetro buscado)
      where: '$_name = ?',
      // O valor do parametro buscado
      whereArgs: [nomeTarefa],
    );
    print('Tararefa encontrada: ${toList(result)}');
    return toList(result);
  }

  Future<List<Task>> findAll() async {
    print('Acessando o findAll: ');
    // await vai esperar a a operação async ser realizada (abre o bd)
    final Database bancoDados = await getDatabase();
    // Map pois os valores serão atribuídos em formato de mapa (chave - valor)
    final List<Map<String, dynamic>> result =
        await bancoDados.query(_tablename);
    print('Procurando dados no bd... encontrado: $result');
    // Passamos o parâmetro solicitado (lista de maps)
    return toList(result);
  }

  // Para manipularmos os dados, eles precisam estar em formato de lista
  // Este método foi criado para converter a lista de map para lista
  // Ela pede uma lista de maps
  List<Task> toList(List<Map<String, dynamic>> mapaTarefas) {
    print('Convertendo toList');
    // Criamos a variável que armazenará a lista convertida
    final List<Task> tarefas = [];
    // Vamos percorrer a lista de maps para convertê-la.
    // A cada iteração o for percorre um elemento da Lista de maps. O valor de cada elemento é atruibuído a variável linha
    for (Map<String, dynamic> linha in mapaTarefas) {
      // Para cada elemento (linha) no mapa de tarefas, criamos uma nova instância da classe Task.
      // Cada instância requer três parâmetros: nome da tarefa, URL e dificuldade.
      // Estamos especificando que cada parâmetro receberá o valor correspondente na linha, utilizando as chaves _name, _url e _difficulty
      final Task tarefa = Task(linha[_name], linha[_url], linha[_difficulty]);
      // E então, é só atribuir o obj de Task a nossa variável da lista de objs
      tarefas.add(tarefa);
    }
    // Depois que percorremos, printamos como forma de depuração
    print('Lista de tarefas $tarefas');
    return tarefas;
  }

  delete(String nomeTarefa) async {
    print('Deletando tarefa $nomeTarefa');
    final Database bancoDados = await getDatabase();
    return bancoDados.delete(
      _tablename,
      where: '$_name = ?',
      whereArgs: [nomeTarefa],
    );
  }
}
