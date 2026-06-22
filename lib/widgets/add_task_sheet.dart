import 'package:flutter/material.dart';
import '../theme/tide_colors.dart';

class AddTaskSheet extends StatefulWidget {
  final void Function(
    String,
    String,
    String,
    DateTime?,
  ) onAdd;

  const AddTaskSheet({
    super.key,
    required this.onAdd,
  });

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final _c = TextEditingController();

  String _priority = 'med';
  String _category = 'Personal';
  DateTime? _dueDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1A1A2E)
            : const Color(0xFFF8F9FD),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '✨ New Task',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : const Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _c,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'What needs doing?',
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF22243A)
                    : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Priority',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['high', 'med', 'low'].map((p) {
                final selected = _priority == p;

                return ChoiceChip(
                  label: Text(p.toUpperCase()),
                  selected: selected,
                  selectedColor: p == 'high'
                      ? TideColors.priHigh
                      : p == 'med'
                          ? TideColors.priMed
                          : TideColors.priLow,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : TideColors.lightMuted,
                  ),
                  onSelected: (_) {
                    setState(() {
                      _priority = p;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              'Category',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _category,
              dropdownColor: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF22243A)
                  : Colors.white,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF22243A)
                    : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Study',
                  child: Text('Study'),
                ),
                DropdownMenuItem(
                  value: 'Work',
                  child: Text('Work'),
                ),
                DropdownMenuItem(
                  value: 'Personal',
                  child: Text('Personal'),
                ),
                DropdownMenuItem(
                  value: 'Fitness',
                  child: Text('Fitness'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _category = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(
                  double.infinity,
                  50,
                ),
                side: const BorderSide(
                  color: TideColors.primary,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              icon: const Icon(Icons.calendar_month),
              label: Text(
                _dueDate == null
                    ? 'Select Due Date'
                    : '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
              ),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2035),
                );

                if (picked != null) {
                  setState(() {
                    _dueDate = picked;
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                ),
                onPressed: () {
                  widget.onAdd(
                    _c.text,
                    _priority,
                    _category,
                    _dueDate,
                  );

                  Navigator.pop(context);
                },
                child: const Text(
                  'Save Task',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
