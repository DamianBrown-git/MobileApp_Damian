import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../models/todo.dart';

const _todosUrl = 'https://jsonplaceholder.typicode.com/todos';

/// Repository that talks to the REST endpoint.
class TodoRepository {
  Future<List<Todo>> fetchTodos() async {
    final response = await http.get(Uri.parse(_todosUrl));
    if (response.statusCode != 200) {
      throw Exception('Failed to load todos (HTTP ${response.statusCode})');
    }
    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    return data.map((e) => Todo.fromJson(e as Map<String, dynamic>)).toList();
  }
}

final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  return TodoRepository();
});

class TodoListNotifier extends AutoDisposeAsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() {
    return ref.read(todoRepositoryProvider).fetchTodos();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(todoRepositoryProvider).fetchTodos(),
    );
  }

  /// Local-only toggle (the API is read-only).
  void toggle(int id) {
    final todos = state.valueOrNull;
    if (todos == null) return;
    state = AsyncData([
      for (final t in todos)
        if (t.id == id) t.copyWith(completed: !t.completed) else t,
    ]);
  }
}

final todoListProvider =
    AsyncNotifierProvider.autoDispose<TodoListNotifier, List<Todo>>(
  TodoListNotifier.new,
);
