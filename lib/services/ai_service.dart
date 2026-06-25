import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {

  // CHANGE THIS TO YOUR PC IP
  static const String baseUrl =
      'https://tide-pro.onrender.com';

  // ---------------- AI Planner ----------------

  Future<String> planMyDay(List<String> tasks) async {

    final response = await http.post(
      Uri.parse('$baseUrl/plan'),

      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode({
        'tasks': tasks,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['plan'];
    }

    throw Exception('Failed to generate plan');
  }

  // ---------------- AI Categorization ----------------

  Future<String> categorizeTask(String title) async {

    final response = await http.post(
      Uri.parse('$baseUrl/categorize'),

      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode({
        'title': title,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['category'];
    }

    return "Personal";
  }

  // ---------------- Semantic Search ----------------

  Future<List<String>> semanticSearch(
      String query,
      List<String> tasks,
      ) async {

    final response = await http.post(
      Uri.parse('$baseUrl/search'),

      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode({
        'query': query,
        'tasks': tasks,
      }),
    );

    if (response.statusCode == 200) {

      final result =
      jsonDecode(response.body)['result'];

      return result
          .toString()
          .split('\n');
    }

    return [];
  }

  // ---------------- AI Chat ----------------

  Future<String> chat(String message) async {

    final response = await http.post(
      Uri.parse('$baseUrl/chat'),

      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode({
        'message': message,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['reply'];
    }

    throw Exception('Chat failed');
  }
}