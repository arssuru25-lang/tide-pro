import 'package:flutter/material.dart';

import 'home_screen.dart';
import '../models/task.dart';

import 'calendar_screen.dart';
import 'analytics_screen.dart';
import 'settings_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentIndex = 0;

  List<Task> tasks = [
    Task(
      title: 'Submit flutter assignment',
      priority: 'high',
    ),
    Task(
      title: 'Call umma @ 6 PM',
    ),
    Task(
      title: 'Gym — leg day',
      priority: 'low',
    ),
    Task(
      title: 'Review Figma prototype',
      isDone: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        HomeScreen(tasks: tasks),
        CalendarScreen(
          tasks: tasks,
        ),
        AnalyticsScreen(
          tasks: tasks,
        ),
        SettingsScreen(
          tasks: tasks,
          onTasksCleared: () {
            setState(() {
              tasks.clear();
            });
          },
        ),
      ][currentIndex],
      bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 20,
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF1A1A2E)
                : Colors.white,
            selectedItemColor: const Color(0xFF6C63FF),
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            items: [
              BottomNavigationBarItem(
                icon: AnimatedScale(
                  duration: const Duration(milliseconds: 250),
                  scale: currentIndex == 0 ? 1.2 : 1,
                  child: const Icon(Icons.home_rounded),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: AnimatedScale(
                  duration: const Duration(milliseconds: 250),
                  scale: currentIndex == 1 ? 1.2 : 1,
                  child: const Icon(Icons.calendar_month_rounded),
                ),
                label: 'Calendar',
              ),
              BottomNavigationBarItem(
                icon: AnimatedScale(
                  duration: const Duration(milliseconds: 250),
                  scale: currentIndex == 2 ? 1.2 : 1,
                  child: const Icon(Icons.bar_chart_rounded),
                ),
                label: 'Analytics',
              ),
              BottomNavigationBarItem(
                icon: AnimatedScale(
                  duration: const Duration(milliseconds: 250),
                  scale: currentIndex == 3 ? 1.2 : 1,
                  child: const Icon(Icons.settings_rounded),
                ),
                label: 'Settings',
              ),
            ],
          )),
    );
  }
}
