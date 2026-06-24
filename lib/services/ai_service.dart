class AIService {
  Future<String> planMyDay(List<String> tasks) async {
    if (tasks.isEmpty) {
      return "No tasks available.";
    }

    tasks.sort();

    return '''
📌 AI Daily Plan

1. ${tasks.isNotEmpty ? tasks[0] : ""}

${tasks.length > 1 ? "2. ${tasks[1]}\n" : ""}
${tasks.length > 2 ? "3. ${tasks[2]}\n" : ""}
${tasks.length > 3 ? "4. ${tasks[3]}\n" : ""}

Priority Order:
• Complete high priority tasks first.
• Finish overdue tasks immediately.
• Group similar tasks together.
• Keep personal tasks for later.

Suggested by AI Planner.
''';
  }

  Future<String> categorizeTask(String title) async {
    final text = title.toLowerCase();

    if (text.contains('study') ||
        text.contains('exam') ||
        text.contains('assignment')) {
      return 'Study';
    }

    if (text.contains('gym') ||
        text.contains('doctor') ||
        text.contains('health')) {
      return 'Health';
    }

    if (text.contains('money') ||
        text.contains('bank') ||
        text.contains('bill')) {
      return 'Finance';
    }

    if (text.contains('office') ||
        text.contains('project') ||
        text.contains('meeting')) {
      return 'Work';
    }

    return 'Personal';
  }

  Future<List<String>> semanticSearch(
      String query, List<String> tasks) async {
    query = query.toLowerCase();

    return tasks
        .where((t) => t.toLowerCase().contains(query))
        .toList();
  }

  Future<String> chat(String prompt) async {
    return '''
🤖 AI Assistant

Question:
$prompt

Answer:
You should focus on your overdue and high priority tasks first.

Keep your workload balanced and complete urgent tasks today.
''';
  }
}