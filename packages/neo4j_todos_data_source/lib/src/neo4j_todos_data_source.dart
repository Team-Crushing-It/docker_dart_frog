import 'package:neo4driver/neo4driver.dart';
import 'package:neo4j_todos_data_source/neo4j_todos_data_source.dart';
import 'package:uuid/uuid.dart';

/// An in-memory implementation of the [TodosDataSource] interface.
class Neo4jTodosDataSource implements TodosDataSource {
  /// initialization. Defaults to port 7474
  Neo4jTodosDataSource() {
    NeoClient.withAuthorization(
      username: 'neo4j',
      password: 'neo4j',
      databaseAddress:'http://neo4j:test@neo4j:7474'
    );
  }

  final _db = NeoClient();

  @override
  Future<Todo> create(Todo todo) async {
    final id = const Uuid().v4();
    final createdTodo = todo.copyWith(id: id);
    await _db
        .createNode(labels: ['Todo'], properties: createdTodo.toJson());
    return createdTodo;
  }

  @override
  Future<List<Todo>> readAll() async {
    List<Node> todos = await _db.findAllNodesByLabel('Todo');
    return todos.map((e) => Todo.fromJson(e.properties)).toList();
  }

  @override
  Future<Todo?> read(String id) async {
    final todo = await _db.findAllNodesByProperties(
      propertiesToCheck: [
        PropertyToCheck(key: 'id', comparisonOperator: '=', value: "'$id'")
      ],
    );
    return Todo.fromJson(todo.first.properties);
  }

  @override
  Future<Todo> update(String id, Todo todo) async {
    final todoNode = await _db.findAllNodesByProperties(
        propertiesToCheck: [
          PropertyToCheck(key: 'id', comparisonOperator: '=', value: "'$id'")
        ]);
    print('hello');
    print(todoNode.first.id);
    final updatedNode = await _db.updateNodeById(
        nodeId: todoNode.first.id!, propertiesToAddOrUpdate: todo.toJson());
    return Todo.fromJson(updatedNode!.properties);
  }

  @override
  Future<void> delete(String id) async {
    final todoNode = await _db.findAllNodesByProperties(
        propertiesToCheck: [
          PropertyToCheck(key: 'id', comparisonOperator: '=', value: id)
        ]);
    await _db.deleteNodeById(todoNode.first.id!);
  }
}
