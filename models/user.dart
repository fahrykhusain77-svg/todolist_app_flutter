class User {
  int? id;
  String username;
  String password;

  User({this.id, required this.username, required this.password});

  // Convert objek User to Map (untuk INSERT / UPDATE)
  Map<String, dynamic> toMap() {
    return {'id': id, 'username': username, 'password': password};
  }

  // Convert Map dari SQLite menjadi objek User
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
    );
  }
}
