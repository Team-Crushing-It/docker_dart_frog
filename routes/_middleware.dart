import 'package:dart_frog/dart_frog.dart';
// import 'package:in_memory_todos_data_source/in_memory_todos_data_source.dart';
import 'package:neo4j_todos_data_source/neo4j_todos_data_source.dart';

final _dataSource = Neo4jTodosDataSource();

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(provider<TodosDataSource>((_) => _dataSource));
}
