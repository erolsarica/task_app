import 'package:isar/isar.dart';

part 'task_model.g.dart';

@collection
class Task {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment

  late String taskText;
  DateTime createdAt = DateTime.now();
  bool isCompleted = false;
}
