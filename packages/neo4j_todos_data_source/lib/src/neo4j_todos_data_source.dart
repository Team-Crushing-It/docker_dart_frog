import 'package:neo4driver/neo4driver.dart';
import 'package:neo4j_todos_data_source/neo4j_todos_data_source.dart';
import 'package:uuid/uuid.dart';

/// An in-memory implementation of the [TodosDataSource] interface.
class Neo4jTodosDataSource implements TodosDataSource {
  /// initialization
  Neo4jTodosDataSource() {
    NeoClient.withAuthorization(
      username: 'neo4j',
      password: '123456',
    );
  }


  @override
  Future<Todo> create(Todo todo) async {
    final id = const Uuid().v4();
    final createdTodo = todo.copyWith(id: id);
    await NeoClient()
        .createNode(labels: ['Todo'], properties: createdTodo.toJson());
    return createdTodo;
  }

  @override
  Future<List<Todo>> readAll() async {
    List<Node> todos = await NeoClient().findAllNodesByLabel('Todo');
    return todos.map((e) => Todo.fromJson(e.properties)).toList();
  }

  @override
  Future<Todo?> read(String id) async {
    final todo = await NeoClient().findAllNodesByProperties(propertiesToCheck: [
      PropertyToCheck(key: 'id', comparisonOperator: '=', value: id)
    ]);
    return Todo.fromJson(todo.first.properties);
  }

  @override
  Future<Todo> update(String id, Todo todo) async {
    final todoNode = await NeoClient().findAllNodesByProperties(
        propertiesToCheck: [
          PropertyToCheck(key: 'id', comparisonOperator: '=', value: id)
        ]);
    print('hello');
    print(todoNode.first.id);
    final updatedNode = await NeoClient().updateNodeById(
        nodeId: todoNode.first.id!, propertiesToAddOrUpdate: todo.toJson());
    return Todo.fromJson(updatedNode!.properties);
  }

  @override
  Future<void> delete(String id) async {
    final todoNode = await NeoClient().findAllNodesByProperties(
        propertiesToCheck: [
          PropertyToCheck(key: 'id', comparisonOperator: '=', value: id)
        ]);
    await NeoClient().deleteNodeById(todoNode.first.id!);
  }
}
