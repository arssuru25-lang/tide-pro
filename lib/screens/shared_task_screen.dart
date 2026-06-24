import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SharedTaskScreen
    extends StatelessWidget {
  final String shareId;

  const SharedTaskScreen({
    super.key,
    required this.shareId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🌊 Shared Task',
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('shared_tasks')
            .doc(shareId)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          if (!snapshot.data!.exists) {
            return const Center(
              child: Text(
                'Task not found',
              ),
            );
          }

          final data =
              snapshot.data!.data()
                  as Map<String, dynamic>;

          return Padding(
            padding:
                const EdgeInsets.all(20),
            child: Card(
              child: Padding(
                padding:
                    const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      data['title'],
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    Text(
                      'Category: ${data['category']}',
                    ),

                    Text(
                      'Priority: ${data['priority']}',
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    const Text(
                      '🔒 Read Only',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}