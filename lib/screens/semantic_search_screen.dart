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

  final TextEditingController controller =
      TextEditingController();

  List<String> results = [];
  bool loading = false;

  Future<void> search() async {

    if (controller.text.trim().isEmpty) return;

    setState(() {
      loading = true;
    });

    try {

      final response =
          await AIService().semanticSearch(
        controller.text.trim(),
        widget.tasks
            .map((e) => e.title)
            .toList(),
      );

      setState(() {
        results = response;
        loading = false;
      });

    } catch (e) {

      setState(() {
        results = ['Error: $e'];
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('🤖 AI Semantic Search'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(
              controller: controller,
              autofocus: false,

              decoration: const InputDecoration(
                hintText: 'Example: weekend tasks',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),

              onSubmitted: (_) => search(),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: search,
              child: const Text('Search'),
            ),

            const SizedBox(height: 20),

            if (loading)
              const CircularProgressIndicator(),

            if (!loading)
              Expanded(
                child: results.isEmpty
                    ? const Center(
                        child: Text(
                          'Type something and press Search',
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