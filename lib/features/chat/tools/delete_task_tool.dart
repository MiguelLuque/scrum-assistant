import 'dart:convert';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrum_assistant/features/board/providers/board_provider.dart';

class DeleteTaskTool {
  static OpenAIToolModel definition() {
    return OpenAIToolModel(
      type: "function",
      function: OpenAIFunctionModel.withParameters(
        name: "deleteTasks",
        description: "Deletes one or more tasks from their columns",
        parameters: [
          OpenAIFunctionProperty.array(
            name: "tasks",
            description: "A list of tasks to delete",
            items: OpenAIFunctionProperty.object(
              name: "task",
              properties: [
                OpenAIFunctionProperty.integer(
                  name: "taskId",
                  description: "The ID of the task to delete",
                  isRequired: true,
                ),
                OpenAIFunctionProperty.integer(
                  name: "columnId",
                  description: "The ID of the column where the task is located",
                  isRequired: true,
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
    final List<dynamic> tasksToDelete = decodedArgs["tasks"];

    for (final taskJson in tasksToDelete) {
      final columnId = taskJson["columnId"] as int;
      final taskId = taskJson["taskId"] as int;

      ref.read(boardNotifierProvider.notifier).deleteTask(
            columnId,
            taskId,
          );
    }
  }
}
