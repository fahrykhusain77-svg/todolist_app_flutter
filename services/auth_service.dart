import 'package:todo_local_app/services/db_service.dart';

class AuthService {
  static Future<int?> login(String username, String password) async {
    final db = await DBService.database;
    final res = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return res.isNotEmpty ? res.first['id'] as int : null;
  }

  static Future<int> register(String username, String password) async {
    final db = await DBService.database;
    return await db.insert('users', {
      'username': username,
      'password': password,
    });
  }
}
