import 'package:flutter/material.dart';
import '../services/ai_service.dart';

class ChatScreen extends StatefulWidget {

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() =>
      _ChatScreenState();
}

class _ChatScreenState
    extends State<ChatScreen> {

  final controller =
      TextEditingController();

  final List<String> messages = [];

  Future<void> send() async {

    final text = controller.text;

    if (text.isEmpty) return;

    setState(() {
      messages.add("You: $text");
    });

    controller.clear();

    final reply =
        await AIService().chat(text);

    setState(() {
      messages.add("Claude: $reply");
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'AI Assistant'),
      ),

      body: Column(
        children: [

          Expanded(
            child: ListView.builder(
              itemCount: messages.length,

              itemBuilder: (_, i) {

                return ListTile(
                  title: Text(
                      messages[i]),
                );
              },
            ),
          ),

          Padding(
            padding:
                const EdgeInsets.all(12),

            child: Row(
              children: [

                Expanded(
                  child: TextField(
                    controller: controller,
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: send,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}