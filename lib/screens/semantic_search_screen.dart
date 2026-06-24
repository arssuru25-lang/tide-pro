import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/ai_service.dart';

class SemanticSearchScreen extends StatefulWidget {
  final List<Task> tasks;

  const SemanticSearchScreen({
    super.key,
    required this.tasks,
  });

  @override
  State<SemanticSearchScreen> createState() =>
      _SemanticSearchScreenState();
}

class _SemanticSearchScreenState
    extends State<SemanticSearchScreen> {

  final controller = TextEditingController();

  List<String> results = [];

  Future<void> search() async {

    final response =
        await AIService().semanticSearch(
      controller.text,
      widget.tasks
          .map((e) => e.title)
          .toList(),
    );

    setState(() {
      results = response;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AI Semantic Search',
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Example: weekend tasks',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: search,
              child: const Text('Search'),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: results.isEmpty
                  ? const Center(
                      child: Text(
                        'No tasks found',
                      ),
                    )
                  : ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: const Icon(
                              Icons.task_alt,
                            ),
                            title: Text(
                              results[index],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}