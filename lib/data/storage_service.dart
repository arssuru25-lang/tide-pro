import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class StorageService {
  static const String taskKey = 'tasks';

  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();

    final taskList = tasks.map((task) {
      return {
        'title': task.title,
        'priority': task.priority,
        'category': task.category,
        'isDone': task.isDone,
        'dueDate': task.dueDate?.toIso8601String(),
      };
    }).toList();

    await prefs.setString(taskKey, jsonEncode(taskList));
  }

  static Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(taskKey);

    if (data == null) return [];

    final decoded = jsonDecode(data) as List;

    return decoded.map((item) {
      return Task(
        title: item['title'],
        priority: item['priority'],
        category: item['category'],
        isDone: item['isDone'],
        dueDate:
            item['dueDate'] != null ? DateTime.parse(item['dueDate']) : null,
      );
    }).toList();
  }
}
