import 'dart:convert';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrum_assistant/features/board/models/task_model.dart';
import 'package:scrum_assistant/features/board/providers/board_provider.dart';

class CreateTaskTool {
  static int _lastId = 0;

  static int _generateUniqueId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    if (timestamp <= _lastId) {
      _lastId += 1;
      return _lastId;
    }
    _lastId = timestamp;
    return timestamp;
  }

  static OpenAIToolModel definition() {
    return OpenAIToolModel(
      type: "function",
      function: OpenAIFunctionModel.withParameters(
        name: "createTasks",
        description: "Creates multiple tasks in specified columns",
        parameters: [
          OpenAIFunctionProperty.array(
            name: "tasks",
            description: "A list of tasks to create",
            items: OpenAIFunctionProperty.object(
              name: "task",
              properties: [
                OpenAIFunctionProperty.integer(
                  name: "id",
                  description: "The ID of the task",
                  isRequired: true,
                ),
                OpenAIFunctionProperty.string(
                  name: "title",
                  description: "The title of the task",
                  isRequired: true,
                ),
                OpenAIFunctionProperty.integer(
                  name: "columnId",
                  description:
                      "The ID of the column where the task will be created",
                  isRequired: true,
                ),
                OpenAIFunctionProperty.string(
                  name: "description",
                  description: "Optional description of the task",
                  isRequired: false,
                ),
                OpenAIFunctionProperty.array(
                  name: "labels",
                  description: "Optional list of labels for the task",
                  isRequired: false,
                  items: OpenAIFunctionProperty.string(
                    name: "label",
                    description: "A label for the task",
                  ),
                ),
                OpenAIFunctionProperty.boolean(
                  name: "isCompleted",
                  description: "Whether the task is completed",
                  isRequired: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> execute({
    required OpenAIResponseToolCall toolCall,
    required WidgetRef ref,
  }) async {
    final decodedArgs = jsonDecode(toolCall.function.arguments);
    final List<dynamic> tasksJson = decodedArgs["tasks"];

    for (final taskJson in tasksJson) {
      final task = TaskModel.fromJson({
        ...taskJson,
        'id': _generateUniqueId(),
        'createdAt': DateTime.now().toIso8601String(),
      });

      ref.read(boardNotifierProvider.notifier).addTaskAction(task);
    }
  }
}
