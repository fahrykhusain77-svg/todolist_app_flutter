import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo_model.dart';
import '../providers/todo_provider.dart';
import 'edit_todo_page.dart';

class TodoDetailPage extends StatelessWidget {
  final Todo todo;

  const TodoDetailPage({super.key, required this.todo});

  String _fmtDate(DateTime d) {
    return "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Tugas"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EditTodoPage(todo: todo)),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              todo.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Text(
              "Tanggal: ${_fmtDate(todo.date)}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),

            Text(
              "Status: ${todo.isDone ? "Selesai" : "Belum"}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            const Text(
              "Deskripsi:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),

            Text(
              (todo.description == null || todo.description!.trim().isEmpty)
                  ? "Tidak ada deskripsi."
                  : todo.description!,
              style: const TextStyle(fontSize: 16),
            ),

            const Spacer(),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              icon: const Icon(Icons.delete),
              label: const Text("Hapus Tugas"),
              onPressed: () async {
                final ctx = context; // simpan context sebelum async gap

                final confirm = await showDialog<bool>(
                  context: ctx,
                  builder: (dialogCtx) => AlertDialog(
                    title: const Text("Hapus Tugas"),
                    content: const Text(
                      "Yakin ingin menghapus tugas ini secara permanen?",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogCtx, false),
                        child: const Text("Batal"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(dialogCtx, true),
                        child: const Text("Hapus"),
                      ),
                    ],
                  ),
                );

                // CEK MOUNTED SESUDAH ASYNC GAP
                if (!ctx.mounted) return;

                if (confirm == true) {
                  ctx.read<TodoProvider>().delete(todo.id!);
                  Navigator.pop(ctx);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
