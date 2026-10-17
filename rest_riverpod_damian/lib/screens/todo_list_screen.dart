import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/todo.dart';
import '../providers/todo_provider.dart';

class TodoListScreen extends ConsumerWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(todoListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFEEF1FA), // soft light background
      appBar: AppBar(
        title: const Text('Todo List'),
        backgroundColor: const Color(0xFFD0BCFF), // stronger purple
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0, // keeps color from changing on scroll
      ),
      body: todosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 12),
                Text('Something went wrong:\n$error',
                    textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () =>
                      ref.read(todoListProvider.notifier).refresh(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (todos) => RefreshIndicator(
          onRefresh: () => ref.read(todoListProvider.notifier).refresh(),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: todos.length,
            itemBuilder: (context, index) => _TodoCard(todo: todos[index]),
          ),
        ),
      ),
    );
  }
}

class _TodoCard extends ConsumerWidget {
  const _TodoCard({required this.todo});
  final Todo todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final done = todo.completed;
    final color = done ? Colors.green : Colors.orange;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      color: const Color(0xFFF8F0FA), // light pink-lavender card
      surfaceTintColor: Colors.transparent, // removes the gray tint
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: color.withValues(alpha: 0.25),
          child: Icon(
            done ? Icons.check : Icons.access_time,
            color: color,
          ),
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            fontSize: 18,
            decoration: done ? TextDecoration.lineThrough : null,
            color: done ? Colors.grey.shade600 : const Color(0xFF1D1B20),
          ),
        ),
        subtitle: Text(
          'Task ID: ${todo.id} | User ID: ${todo.userId}',
          style: TextStyle(color: Colors.grey.shade800),
        ),
        trailing: Checkbox(
          value: done,
          onChanged: (_) =>
              ref.read(todoListProvider.notifier).toggle(todo.id),
        ),
      ),
    );
  }
}