import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_stats_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('👤 Profile'),
      ),
      body: StreamBuilder(
        stream: UserStatsService.statsStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              snapshot.data!.data() == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data =
              snapshot.data!.data()
                  as Map<String, dynamic>;

          final xp = data['xp'] ?? 0;
          final streak = data['streak'] ?? 0;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor:
                    const Color(0xFF6C63FF),
                child: Text(
                  user?.email
                          ?.substring(0, 1)
                          .toUpperCase() ??
                      'U',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: Text(
                  user?.email ?? 'Guest',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              _infoCard(
                '⭐ Total XP',
                '$xp XP',
                Colors.amber,
              ),

              _infoCard(
                '🔥 Current Streak',
                '$streak Days',
                Colors.orange,
              ),

              _infoCard(
                '🏆 Level',
                '${(xp ~/ 100) + 1}',
                Colors.purple,
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1A1A2E)
                      : Colors.white,
                  borderRadius:
                      BorderRadius.circular(24),
                ),
                child: const Column(
                  children: [
                    Text(
                      'Tide Pro v2.0',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Stay productive. Stay focused.',
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _infoCard(
    String title,
    String value,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 16,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}