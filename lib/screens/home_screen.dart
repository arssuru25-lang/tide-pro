import 'package:flutter/material.dart';
import '../models/task.dart';
import '../theme/tide_colors.dart';
import '../widgets/task_card.dart';
import '../widgets/add_task_sheet.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
class HomeScreen extends StatefulWidget {
  final List<Task> tasks;

  const HomeScreen({
    super.key,
    required this.tasks,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> get tasks => widget.tasks;
  @override
  void initState() {
    super.initState();
   
  }

  bool isDark = false;
  String selectedFilter = 'All';
  String selectedCategory = 'All';
  String searchQuery = '';
  final List<String> categories = [
    'All',
    'Study',
    'Work',
    'Personal',
    'Fitness',
    'Shopping',
  ];
  String greeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good Morning ☀️';
    } else if (hour < 17) {
      return 'Good Afternoon 🌤️';
    } else {
      return 'Good Evening 🌙';
    }
  }

  void _editTask(
    Task task,
    String title,
    String priority,
    String category,
  ) {
    setState(() {
      task.title = title;
      task.priority = priority;
      task.category = category;
    });

   
    FirestoreService.updateTask(task);
  }

  

  void _toggle(Task t) {
    if (tasks.isNotEmpty && tasks.every((task) => task.isDone)) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            '🏆 Congratulations!',
          ),
          content: const Text(
            'You completed all tasks!',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Awesome!'),
            ),
          ],
        ),
      );
    }
    setState(() {
      t.isDone = !t.isDone;
    });

    if (t.isDone) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '🎉 "${t.title}" completed!',
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }

    
   FirestoreService.updateTask(t);
  }

 void _add(
  String title,
  String priority,
  String category,
  DateTime? dueDate,
) {
  if (title.trim().isEmpty) return;

  final task = Task(
    title: title.trim(),
    priority: priority,
    category: category,
    dueDate: dueDate,
  );

  setState(() {
    tasks.add(task);
  });



  FirestoreService.addTask(task);
}
  void _openSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? TideColors.darkCard : TideColors.lightCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (_) => AddTaskSheet(
        onAdd: _add,
      ),
    );
  }

  void _openEditSheet(Task task) {
    final controller = TextEditingController(text: task.title);

    String priority = task.priority;
    String category = task.category;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Edit Task',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Task title',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: ['high', 'med', 'low'].map((p) {
                      return ChoiceChip(
                        label: Text(p.toUpperCase()),
                        selected: priority == p,
                        onSelected: (_) {
                          setModalState(() {
                            priority = p;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: [
                      'Study',
                      'Work',
                      'Personal',
                      'Fitness',
                    ].map((cat) {
                      return ChoiceChip(
                        label: Text(cat),
                        selected: category == cat,
                        onSelected: (_) {
                          setModalState(() {
                            category = cat;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _editTask(
                          task,
                          controller.text,
                          priority,
                          category,
                        );

                        Navigator.pop(context);
                      },
                      child: const Text('Save Changes'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _statCard(
    String title,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.20),
            blurRadius: 18,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

   
    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF121212) : TideColors.lightSurface,
      appBar: AppBar(
        title: const Text('Tide Pro 2.0'),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              setState(() {
                isDark = !isDark;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              greeting(),
              style: const TextStyle(
                color: Color(0xFFFF8A00),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            Text(
              'Today',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : const Color(0xFF1E1B4B),
              ),
            ),
           
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFF8A00),
                    Color(0xFFFF5E62),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withValues(alpha: 0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Row(
                children: [
                  Text(
                    '🔥',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '7 Day Streak',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Keep completing tasks!',
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
           
            const SizedBox(height: 8),
            TextField(
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF2D3748),
                fontWeight: FontWeight.w500,
              ),
              cursorColor: TideColors.primary,
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                hintStyle: TextStyle(
                  color:
                      isDark ? Colors.grey.shade400 : const Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xFF6C63FF),
                ),
                filled: true,
                fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = categories[index];

                  return ChoiceChip(
                    label: Text(filter),
                    selected: selectedFilter == filter,
                    onSelected: (_) {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Tasks',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
           
          StreamBuilder<QuerySnapshot>(
  stream: FirestoreService.taskStream(),
  builder: (context, snapshot) {
    if (snapshot.connectionState ==
        ConnectionState.waiting) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!snapshot.hasData ||
        snapshot.data!.docs.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text('No tasks yet 🌊'),
        ),
      );
    }

    final docs = snapshot.data!.docs;

    final firestoreTasks = docs.map((doc) {
      return Task.fromMap(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    }).toList();
   final completed =
    firestoreTasks.where((t) => t.isDone).length;

final remaining =
    firestoreTasks.where((t) => !t.isDone).length;

final total = firestoreTasks.length;

final progress =
    total == 0 ? 0.0 : completed / total;

final filteredTasks = firestoreTasks.where((task) {
  final matchesCategory =
      selectedFilter == 'All' ||
      task.category == selectedFilter;

  final matchesSearch = task.title.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );

  return matchesCategory && matchesSearch;
}).toList();
return Column(
  children: [

    Text(
      '$remaining tasks remaining',
      style: TextStyle(
        color: isDark
            ? Colors.grey.shade400
            : TideColors.lightMuted,
      ),
    ),

    const SizedBox(height: 20),

    SizedBox(
      height: 80,
      child: Row(
        children: [
          Expanded(
            child: _statCard(
              'Total',
              total.toString(),
              const Color(0xFF6C63FF),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _statCard(
              'Done',
              completed.toString(),
              const Color(0xFF22C55E),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _statCard(
              'Left',
              remaining.toString(),
              const Color(0xFFEF4444),
            ),
          ),
        ],
      ),
    ),

    const SizedBox(height: 6),

    Column(
      children: [
        Text(
          'Progress ${(progress * 100).toInt()}%',
          style: const TextStyle(
            color: Color(0xFF6C63FF),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          minHeight: 8,
          borderRadius: BorderRadius.circular(10),
          backgroundColor: Colors.grey.shade300,
          color: TideColors.primary,
        ),
      ],
    ),

    const SizedBox(height: 12),

    Text(
      'Tasks Found: ${filteredTasks.length}',
      style: const TextStyle(
        color: Colors.red,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    const SizedBox(height: 12),

ListView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  itemCount: filteredTasks.length,
  itemBuilder: (context, index) {
    final task = filteredTasks[index];

    return Dismissible(
      key: Key(task.id ?? task.title),

      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),

      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),

      onDismissed: (_) async {
        if (task.id != null) {
          await FirestoreService.deleteTask(task.id!);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '"${task.title}" deleted',
            ),
          ),
        );
      },

      child: TaskCard(
        task: task,
        onTap: () => _toggle(task),
        onLongPress: () => _openEditSheet(task),
      ),
    );
  },
),
  ],
);
  },
          ),
          
               ],
        ),
      ), 
           floatingActionButton: FloatingActionButton(
        backgroundColor: TideColors.primary,
        onPressed: _openSheet,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}