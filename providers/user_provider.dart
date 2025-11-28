import 'package:flutter/material.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  // ✔ Set user saat login berhasil
  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  // ✔ Validasi login
  bool login(String username, String password) {
    if (_user == null) return false;
    if (_user!.username != username) return false;
    if (_user!.password != password) return false;
    return true;
  }

  // ✔ Update profile (diperlukan untuk EditProfilePage)
  void updateProfile(String newUsername, String newPassword) {
    if (_user != null) {
      _user!.username = newUsername;
      _user!.password = newPassword;
      notifyListeners();
    }
  }

  // ✔ Logout
  void logout() {
    _user = null;
    notifyListeners();
  }
}
