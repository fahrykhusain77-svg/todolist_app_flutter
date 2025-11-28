// lib/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/todo_provider.dart';
import '../providers/theme_provider.dart';

import 'add_todo_page.dart';
import 'edit_todo_page.dart';
import 'todo_detail_page.dart';
import 'profile_page.dart'; // ← Tambahan penting

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _fmtDate(DateTime d) {
    return "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To-Do List"),
        actions: [
          // === TOMBOL PROFIL BARU ===
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: "Profil",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
          ),

          IconButton(
            icon: Icon(
              context.watch<ThemeProvider>().isDark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () => context.read<ThemeProvider>().toggleTheme(),
          ),
        ],
      ),

      // =======================
      //       FILTER BAR
      // =======================
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Consumer<TodoProvider>(
          builder: (_, provider, _) {
            return DropdownButton<TodoFilter>(
              isExpanded: true,
              value: provider.filter,
              items: const [
                DropdownMenuItem(
                  value: TodoFilter.all,
                  child: Text("Semua Tugas"),
                ),
                DropdownMenuItem(
                  value: TodoFilter.today,
                  child: Text("Tugas Hari Ini"),
                ),
                DropdownMenuItem(
                  value: TodoFilter.completed,
                  child: Text("Selesai"),
                ),
                DropdownMenuItem(
                  value: TodoFilter.pending,
                  child: Text("Belum Selesai"),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  provider.setFilter(value);
                }
              },
            );
          },
        ),
      ),

      // =======================
      //       LIST VIEW
      // =======================
      body: Consumer<TodoProvider>(
        builder: (_, provider, _) {
          final todos = provider.filteredTodos;

          if (todos.isEmpty) {
            return const Center(
              child: Text("Tidak ada tugas untuk filter ini."),
            );
          }

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, i) {
              final todo = todos[i];
              final dateText = _fmtDate(todo.date);

              return Dismissible(
                key: ValueKey(todo.id),

                background: Container(
                  color: Colors.blue,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20),
                  child: const Icon(Icons.edit, color: Colors.white),
                ),

                secondaryBackground: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),

                confirmDismiss: (direction) async {
                  // Edit
                  if (direction == DismissDirection.startToEnd) {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditTodoPage(todo: todo),
                      ),
                    );

                    if (!context.mounted) return false;
                    return false;
                  }

                  // Delete
                  if (direction == DismissDirection.endToStart) {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Hapus Tugas"),
                        content: const Text("Yakin ingin menghapus tugas ini?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("Batal"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text("Hapus"),
                          ),
                        ],
                      ),
                    );

                    if (!context.mounted) return false;

                    if (confirmed == true) {
                      context.read<TodoProvider>().delete(todo.id!);
                      return true;
                    }

                    return false;
                  }

                  return false;
                },

                child: ListTile(
                  title: Text(todo.title),
                  subtitle: Text(dateText),
                  trailing: Checkbox(
                    value: todo.isDone,
                    onChanged: (_) {
                      context.read<TodoProvider>().toggleStatus(todo.id!);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TodoDetailPage(todo: todo),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTodoPage()),
          );

          if (!context.mounted) return;
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
