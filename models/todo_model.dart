class Todo {
  int? id;
  String title;
  String? description;
  bool isDone;
  DateTime date;

  Todo({
    this.id,
    required this.title,
    this.description,
    this.isDone = false,
    required this.date,
  });
}
