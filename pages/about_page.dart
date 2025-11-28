// lib/pages/about_page.dart

import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About App")),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "Aplikasi To-Do List versi 1.0\n\n"
          "Dibuat untuk pembelajaran dan manajemen tugas pribadi.\n"
          "Fitur: Tambah Tugas, Edit, Hapus, Filter, Tema Gelap, User Profile.",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
