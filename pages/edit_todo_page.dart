import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import '../models/todo_model.dart';

class EditTodoPage extends StatefulWidget {
  final Todo todo;

  const EditTodoPage({super.key, required this.todo});

  @override
  State<EditTodoPage> createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleC;
  late TextEditingController _descC;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleC = TextEditingController(text: widget.todo.title);
    _descC = TextEditingController(text: widget.todo.description);
    _selectedDate = widget.todo.date;
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (d != null) setState(() => _selectedDate = d);
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      Provider.of<TodoProvider>(context, listen: false).updateTodo(
        widget.todo.id!,
        _titleC.text.trim(),
        _descC.text.trim(),
        _selectedDate, // sudah DateTime
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Tugas")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleC,
                decoration: const InputDecoration(
                  labelText: "Judul",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? "Judul wajib diisi" : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _descC,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Deskripsi",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(child: Text("Tanggal: $formattedDate")),
                  TextButton.icon(
                    icon: const Icon(Icons.calendar_today),
                    label: const Text("Pilih"),
                    onPressed: _pickDate,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Simpan Perubahan"),
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
