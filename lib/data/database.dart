import 'package:projeto/data/task_dao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Future vai dizer ao nosso app que essa função levará um tempo até receber o retorno. Ele representa um valor que será disponibilizado no futuro. Neste caso um dataBase
Future<Database> getDatabase() async {
  // Combinando o caminho retornado por getDatabasesPath() com o nome do arquivo do banco de dados ('task.db') usando join().
  // await irá esperar o resultado da operação async antes de prosseguir
  final String path = join(await getDatabasesPath(), 'task.db');
  // Se o banco for encontrado = open. Se não, ele é criado
  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(TaskDao.tableSql );
    },
    version: 1,
  );
}

