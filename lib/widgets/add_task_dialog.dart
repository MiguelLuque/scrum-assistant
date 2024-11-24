import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/task_model.dart';

class AddTaskDialog extends HookConsumerWidget {
  final String columnId;

  const AddTaskDialog({
    super.key,
    required this.columnId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    return AlertDialog(
      title: const Text('Add Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final task = TaskModel(
              id: DateTime.now().toString(),
              title: titleController.text,
              description: descriptionController.text.isEmpty
                  ? null
                  : descriptionController.text, columnId: '',
            );
            Navigator.of(context).pop(task);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
} 