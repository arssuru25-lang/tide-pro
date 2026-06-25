import 'package:flutter/material.dart';
import '../services/ai_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final TextEditingController controller =
      TextEditingController();

  final List<Map<String, String>> messages = [];

  bool loading = false;

  Future<void> sendMessage() async {

    if (controller.text.trim().isEmpty) return;

    final text = controller.text;

    setState(() {
      messages.add({
        'sender': 'You',
        'message': text,
      });

      loading = true;
    });

    controller.clear();

    try {

      final reply =
          await AIService().chat(text);

      setState(() {
        messages.add({
          'sender': 'AI',
          'message': reply,
        });
      });

    } catch (e) {

      setState(() {
        messages.add({
          'sender': 'AI',
          'message': 'Error: $e',
        });
      });
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🤖 AI Assistant',
        ),
      ),

      body: Column(
        children: [

          Expanded(
            child: ListView.builder(
              itemCount: messages.length,

              itemBuilder: (context, index) {

                final msg = messages[index];

                return ListTile(
                  title: Text(
                    msg['sender']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Text(
                    msg['message']!,
                  ),
                );
              },
            ),
          ),

          if (loading)
            const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            ),

          Padding(
            padding: const EdgeInsets.all(10),

            child: Row(
              children: [

                Expanded(
                  child: TextField(
                    controller: controller,

                    decoration:
                        const InputDecoration(
                      hintText:
                          'Ask anything...',
                      border:
                          OutlineInputBorder(),
                    ),
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}