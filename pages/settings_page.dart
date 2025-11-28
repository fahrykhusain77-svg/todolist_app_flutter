import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import 'edit_profile_page.dart';
import 'about_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),

      body: ListView(
        children: [
          // 🔥 Dark / Light Mode Switch
          SwitchListTile(
            title: const Text("Dark Mode"),
            value: themeProvider.isDark,
            onChanged: (_) => themeProvider.toggleTheme(),
            secondary: const Icon(Icons.dark_mode),
          ),

          const Divider(),

          // 👤 User Profile
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("User Profile"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfilePage()),
              );
            },
          ),

          // ℹ️ About App
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("About App"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
