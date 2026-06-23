import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/task.dart';
import '../services/user_stats_service.dart';

class AnalyticsScreen extends StatelessWidget {
  final List<Task> tasks;

  const AnalyticsScreen({
    super.key,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('📊 Analytics'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(
              FirebaseAuth
                  .instance.currentUser!.uid,
            )
            .collection('tasks')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final firestoreTasks =
              snapshot.data!.docs
                  .map(
                    (doc) => Task.fromMap(
                      doc.data()
                          as Map<String, dynamic>,
                      doc.id,
                    ),
                  )
                  .toList();

          final totalTasks =
              firestoreTasks.length;

          final completedTasks =
              firestoreTasks
                  .where((t) => t.isDone)
                  .length;

          final pendingTasks =
              totalTasks - completedTasks;

          final successRate =
              totalTasks == 0
                  ? 0
                  : ((completedTasks /
                              totalTasks) *
                          100)
                      .round();

          final highPriority =
              firestoreTasks
                  .where(
                    (t) =>
                        t.priority == 'high',
                  )
                  .length;

          return SafeArea(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient:
                          const LinearGradient(
                        colors: [
                          Color(0xFF6C63FF),
                          Color(0xFF8B5CF6),
                        ],
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        24,
                      ),
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.analytics_rounded,
                          color: Colors.white,
                          size: 50,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Productivity Insights',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: _statCard(
                          totalTasks.toString(),
                          'Total Tasks',
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _statCard(
                          completedTasks
                              .toString(),
                          'Completed',
                          Colors.green,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _statCard(
                          pendingTasks.toString(),
                          'Pending',
                          Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _statCard(
                          '$successRate%',
                          'Success Rate',
                          Colors.purple,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _statCard(
                          highPriority.toString(),
                          'High Priority',
                          Colors.red,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _statCard(
                          '${DateTime.now().day}',
                          'Today',
                          Colors.teal,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  StreamBuilder(
                    stream:
                        UserStatsService
                            .statsStream(),
                    builder:
                        (context, statSnapshot) {
                      if (!statSnapshot
                              .hasData ||
                          statSnapshot.data!
                                  .data() ==
                              null) {
                        return const SizedBox();
                      }

                      final data =
                          statSnapshot.data!
                                  .data()
                              as Map<String,
                                  dynamic>;

                      final streak =
                          data['streak'] ?? 0;

                      final xp =
                          data['xp'] ?? 0;

                      return Column(
                        children: [
                          Container(
                            width:
                                double.infinity,
                            padding:
                                const EdgeInsets
                                    .all(20),
                            decoration:
                                BoxDecoration(
                              color: isDark
                                  ? const Color(
                                      0xFF1A1A2E)
                                  : Colors.white,
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                20,
                              ),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  '🔥 Current Streak',
                                  style:
                                      TextStyle(
                                    fontSize:
                                        18,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '$streak Days',
                                  style:
                                      const TextStyle(
                                    fontSize:
                                        34,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                    color: Color(
                                        0xFF6C63FF),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 16,
                          ),

                          Container(
                            width:
                                double.infinity,
                            padding:
                                const EdgeInsets
                                    .all(20),
                            decoration:
                                BoxDecoration(
                              color: isDark
                                  ? const Color(
                                      0xFF1A1A2E)
                                  : Colors.white,
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                20,
                              ),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  '⭐ Total XP',
                                  style:
                                      TextStyle(
                                    fontSize:
                                        18,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '$xp XP',
                                  style:
                                      const TextStyle(
                                    fontSize:
                                        34,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                    color: Colors
                                        .amber,
                                  ),
                                ),
                              ],
                            ),
                          ),
                         const SizedBox(height: 24),

Align(
  alignment: Alignment.centerLeft,
  child: Text(
    'Weekly Activity',
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: isDark
          ? Colors.white
          : Colors.black,
    ),
  ),
),

const SizedBox(height: 16),

const SizedBox(
  height: 110,
  child: Row(
    mainAxisAlignment:
        MainAxisAlignment.spaceAround,
    crossAxisAlignment:
        CrossAxisAlignment.end,
    children: [
      _Bar(35, 'M'),
      _Bar(55, 'T'),
      _Bar(25, 'W'),
      _Bar(75, 'T'),
      _Bar(45, 'F'),
      _Bar(85, 'S'),
      _Bar(65, 'S'),
    ],
  ),
), 
                        ],
                      );
                    
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static Widget _statCard(
    String value,
    String label,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          Text(label),
        ],
      ),
    );
  }
}
class _Bar extends StatelessWidget {
  final double height;
  final String label;

  const _Bar(this.height, this.label);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 22,
            height: height,
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF),
              borderRadius:
                  BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}