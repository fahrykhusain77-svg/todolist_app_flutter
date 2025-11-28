// lib/providers/todo_provider.dart
import 'package:flutter/material.dart';
import '../models/todo_model.dart';

enum TodoFilter { all, today, completed, pending }

class TodoProvider extends ChangeNotifier {
  final List<Todo> _todos = [];
  TodoFilter _filter = TodoFilter.all;

  List<Todo> get todos => _todos;

  // -----------------------------
  // FILTERING
  // -----------------------------
  List<Todo> get filteredTodos {
    switch (_filter) {
      case TodoFilter.today:
        final now = DateTime.now();
        return _todos
            .where(
              (t) =>
                  t.date.year == now.year &&
                  t.date.month == now.month &&
                  t.date.day == now.day,
            )
            .toList();

      case TodoFilter.completed:
        return _todos.where((t) => t.isDone).toList();

      case TodoFilter.pending:
        return _todos.where((t) => !t.isDone).toList();

      case TodoFilter.all:
        return List<Todo>.from(_todos);
    }
  }

  TodoFilter get filter => _filter;

  void setFilter(TodoFilter f) {
    _filter = f;
    notifyListeners();
  }

  // -----------------------------
  // CRUD
  // -----------------------------
  void addTodo(String title, String? description, DateTime date) {
    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      description: description,
      isDone: false,
      date: date,
    );

    _todos.add(newTodo);
    notifyListeners();
  }

  void delete(int id) {
    _todos.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void updateTodo(int id, String title, String? description, DateTime date) {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index == -1) return;

    final todo = _todos[index];
    todo.title = title;
    todo.description = description;
    todo.date = date;

    notifyListeners();
  }

  void toggleStatus(int id) {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index == -1) return;

    _todos[index].isDone = !_todos[index].isDone;
    notifyListeners();
  }
}
