import 'package:flutter/material.dart';
import '../models/task.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/user_stats_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'achievements_screen.dart';
class SettingsScreen extends StatefulWidget {
  final List<Task> tasks;
  final VoidCallback onTasksCleared;

  const SettingsScreen({
    super.key,
    required this.tasks,
    required this.onTasksCleared,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('⚙ Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF6C63FF),
                  Color(0xFF8B5CF6),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.waves,
                    size: 40,
                    color: Color(0xFF6C63FF),
                  ),
                ),
                const SizedBox(height: 12),
               Text(
  user?.email ?? 'Tide User',
  style: const TextStyle(
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
),
                const Text(
  'Logged in successfully',
  style: TextStyle(
    color: Colors.white70,
  ),
),
                const SizedBox(height: 8),
                Text(
                  '${widget.tasks.length} Tasks Stored',
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance
      .collection('tasks')
      .snapshots(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return const SizedBox();
    }

    final taskCount = snapshot.data!.docs.length;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.bar_chart,
          color: Color(0xFF6C63FF),
        ),
        title: const Text('Account Stats'),
        subtitle: Text(
          '$taskCount tasks created',
        ),
      ),
    );
  
  },
),
StreamBuilder(
  stream: UserStatsService.statsStream(),
  builder: (context, snapshot) {

    if (!snapshot.hasData ||
        snapshot.data!.data() == null) {
      return const SizedBox();
    }

    final data =
        snapshot.data!.data() as Map<String, dynamic>;

    final xp = data['xp'] ?? 0;
    final level = data['level'] ?? 1;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.star,
          color: Colors.amber,
        ),
        title: Text('XP: $xp'),
        subtitle: Text('Level $level'),
      ),
    );
  },
),
StreamBuilder(
  stream: UserStatsService.statsStream(),
  builder: (context, snapshot) {

    if (!snapshot.hasData ||
        snapshot.data!.data() == null) {
      return const SizedBox();
    }

    final data =
        snapshot.data!.data() as Map<String, dynamic>;

    final streak = data['streak'] ?? 0;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.local_fire_department,
          color: Colors.orange,
        ),
        title: Text(
          'Current Streak: $streak days',
        ),
        subtitle: const Text(
          'Keep the momentum going!',
        ),
      ),
    );
  },
),
          const SizedBox(height: 24),
          Card(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(18),
  ),
  child: ListTile(
    leading: const Icon(
      Icons.logout,
      color: Colors.red,
    ),
    title: const Text('Logout'),
    onTap: () async {
      await AuthService.logout();
    },
  ),
),

Card(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(18),
  ),
  child: SwitchListTile(
    secondary: const Icon(
      Icons.dark_mode,
      color: Color(0xFF6C63FF),
    ),
    title: const Text(
      'Dark Mode',
    ),
    subtitle: const Text(
      'Switch app appearance',
    ),

    value:
        context.watch<ThemeProvider>().isDark,

    onChanged: (value) {
      context
          .read<ThemeProvider>()
          .toggleTheme();
    },
  ),
),
             
         Card(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(18),
  ),
  child: SwitchListTile(
    secondary: const Icon(
      Icons.notifications,
      color: Color(0xFF6C63FF),
    ),
    title: const Text(
      'Notifications',
    ),
    subtitle: const Text(
      'Task reminders and alerts',
    ),
    value: notificationsEnabled,
    onChanged: (value) {
      setState(() {
        notificationsEnabled = value;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            value
                ? 'Notifications Enabled'
                : 'Notifications Disabled',
          ),
        ),
      );
    },
  ),
),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
              title: const Text(
                'Clear All Tasks',
              ),
              subtitle: const Text(
                'Remove all saved tasks',
              ),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text(
                      '⚠ Clear All Tasks',
                    ),
                    content: const Text(
                      'This action cannot be undone.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Cancel',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          widget.onTasksCleared();

                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'All tasks cleared',
                              ),
                            ),
                            

                          );
                        },
                        child: const Text(
                          'Clear',
                        ),
                      ),
                     

                    ],
                  ),
                );
              },
            ),
          ),
          Card(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(18),
  ),
  child: ListTile(
    leading: const Icon(
      Icons.emoji_events,
      color: Colors.amber,
    ),
    title: const Text(
      'Achievements',
    ),
    subtitle: const Text(
      'View your progress',
    ),
    trailing: const Icon(
      Icons.chevron_right,
    ),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const AchievementsScreen(),
        ),
      );
    },
  ),
),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.info_outline,
                color: Color(0xFF6C63FF),
              ),
              title: const Text(
                'About Tide Pro',
              ),
              subtitle: const Text(
                'App information',
              ),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Tide Pro',
                  applicationVersion: 'v2.0',
                  applicationLegalese: 'Built with Flutter 💙',
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              children: [
                Text(
                  'Version',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text('v2.0.0'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
