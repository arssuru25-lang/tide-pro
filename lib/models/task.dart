import 'package:flutter/material.dart';
import '../theme/tide_colors.dart';

class Task {
  String? id;
  String title;
  String priority;
  String category;
  DateTime? dueDate;
  bool isDone;

  Task({
    this.id,
    required this.title,
    this.priority = 'med',
    this.category = 'Personal',
    this.dueDate,
    this.isDone = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'priority': priority,
      'category': category,
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'isDone': isDone,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map, String docId) {
    return Task(
      id: docId,
      title: map['title'] ?? '',
      priority: map['priority'] ?? 'med',
      category: map['category'] ?? 'Personal',
      dueDate: map['dueDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dueDate'])
          : null,
      isDone: map['isDone'] ?? false,
    );
  }

  Color get priorityColor {
    if (priority == 'high') return TideColors.priHigh;
    if (priority == 'low') return TideColors.priLow;
    return TideColors.priMed;
  }
}