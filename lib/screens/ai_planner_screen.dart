import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/ai_service.dart';

class AIPlannerScreen extends StatefulWidget {
  final List<Task> tasks;

  const AIPlannerScreen({
    super.key,
    required this.tasks,
  });

  @override
  State<AIPlannerScreen> createState() =>
      _AIPlannerScreenState();
}

class _AIPlannerScreenState
    extends State<AIPlannerScreen> {

  String result = '';
  bool loading = false;

  Future<void> generatePlan() async {
    setState(() {
      loading = true;
    });

    try {
      final taskTitles =
          widget.tasks.map((e) => e.title).toList();

      final plan =
          await 
          AIService().planMyDay(taskTitles);

      setState(() {
        result = plan;
        loading = false;
      });
    } catch (e) {
      setState(() {
        result = "Error: $e";
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    generatePlan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤖 AI Planner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            ElevatedButton(
              onPressed: generatePlan,
              child: const Text('Plan My Day'),
            ),

            const SizedBox(height: 20),

            if (loading)
              const CircularProgressIndicator(),

            if (!loading)
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    result,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}