class Todo {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  const Todo({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        userId: json['userId'] as int,
        id: json['id'] as int,
        title: json['title'] as String,
        completed: json['completed'] as bool,
      );

  Todo copyWith({bool? completed}) => Todo(
        userId: userId,
        id: id,
        title: title,
        completed: completed ?? this.completed,
      );
}
