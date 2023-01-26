import 'package:todos_data_source/todos_data_source.dart';
import 'package:uuid/uuid.dart';

/// An Neo4j implementation of the [TodosDataSource] interface.
class Neo4jTodosDataSource implements TodosDataSource {
  /// Map of ID -> Todo
  final _cache = <String, Todo>{};

  @override
  Future<Todo> create(Todo todo) async {
    final id = const Uuid().v4();
    final createdTodo = todo.copyWith(id: id);

    // code to store this Neo4j
    _cache[id] = createdTodo;
    return createdTodo;
  }

  @override
  Future<List<Todo>> readAll() async => _cache.values.toList();

  @override
  Future<Todo?> read(String id) async => _cache[id];

  @override
  Future<Todo> update(String id, Todo todo) async {
    return _cache.update(id, (value) => todo);
  }

  @override
  Future<void> delete(String id) async => _cache.remove(id);
}
