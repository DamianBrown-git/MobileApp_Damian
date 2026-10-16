import 'package:flutter/material.dart';

import 'todo_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        backgroundColor: theme.colorScheme.primaryContainer,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Welcome to the Flutter Todo App!',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'Tap the button below to fetch and view todos from the REST API.',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium
                    ?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),
              FilledButton.tonalIcon(
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Go to Todo List'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const TodoListScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
