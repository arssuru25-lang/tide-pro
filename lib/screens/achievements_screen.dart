import 'package:flutter/material.dart';
import '../services/user_stats_service.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('🏆 Achievements'),
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
              _achievementCard(
                context,
                icon: '🥇',
                title: 'First Steps',
                subtitle:
                    'Complete your first task',
                unlocked: xp >= 10,
                color: Colors.amber,
              ),

              _achievementCard(
                context,
                icon: '🔥',
                title: 'On Fire',
                subtitle:
                    'Maintain a 7-day streak',
                unlocked: streak >= 7,
                color: Colors.orange,
              ),

              _achievementCard(
                context,
                icon: '⭐',
                title: 'XP Collector',
                subtitle: 'Earn 100 XP',
                unlocked: xp >= 100,
                color: Colors.blue,
              ),

              _achievementCard(
                context,
                icon: '🚀',
                title: 'Productivity Master',
                subtitle: 'Earn 500 XP',
                unlocked: xp >= 500,
                color: Colors.purple,
              ),

              _achievementCard(
                context,
                icon: '🌊',
                title: 'Tide Legend',
                subtitle:
                    'Reach 30-day streak',
                unlocked: streak >= 30,
                color: Colors.teal,
              ),

              const SizedBox(height: 30),

              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1A1A2E)
                      : Colors.white,
                  borderRadius:
                      BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: 0.05,
                      ),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Current Progress',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      '⭐ XP: $xp',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      '🔥 Streak: $streak Days',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
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

  Widget _achievementCard(
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
    required bool unlocked,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: unlocked
            ? color.withValues(alpha: 0.15)
            : Colors.grey.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Text(
            icon,
            style: const TextStyle(
              fontSize: 34,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(subtitle),
              ],
            ),
          ),

          Icon(
            unlocked
                ? Icons.lock_open
                : Icons.lock,
            color: unlocked
                ? Colors.green
                : Colors.grey,
          ),
        ],
      ),
    );
  }
}