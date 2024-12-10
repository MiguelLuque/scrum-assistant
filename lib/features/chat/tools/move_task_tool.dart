import 'dart:convert';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrum_assistant/features/board/providers/board_provider.dart';
import 'package:scrum_assistant/features/chat/models/task_move_group_action.dart';

class MoveTaskTool {
  static OpenAIToolModel definition() {
    return OpenAIToolModel(
      type: "function",
      function: OpenAIFunctionModel.withParameters(
        name: "moveTask",
        description: "Moves multiple tasks to a destination column",
        parameters: [
          OpenAIFunctionProperty.array(
            name: "taskMoveGroups",
            description: "A list of task move groups",
            items: OpenAIFunctionProperty.object(
              name: "taskMoveGroup",
              properties: [
                OpenAIFunctionProperty.array(
                  name: "taskIds",
                  description: "The IDs of the tasks to move",
                  isRequired: true,
                  items: OpenAIFunctionProperty.integer(
                    name: "taskId",
                    description: "The ID of the task to move",
                  ),
                ),
                OpenAIFunctionProperty.integer(
                  name: "destinationColumnId",
                  description: "The ID of the destination column",
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
    final List<dynamic> taskMoveGroupsJson = decodedArgs["taskMoveGroups"];

    final List<TaskMoveGroupAction> taskMoveGroups =
        taskMoveGroupsJson.map((json) {
      return TaskMoveGroupAction(
        taskIds: List<int>.from(json["taskIds"]),
        destinationColumnId: json["destinationColumnId"],
      );
    }).toList();

    for (final taskMoveGroup in taskMoveGroups) {
      for (final taskId in taskMoveGroup.taskIds) {
        final task = ref
            .read(boardNotifierProvider)
            .expand((column) => column.tasks)
            .firstWhere((task) => task.id == taskId);

        ref.read(boardNotifierProvider.notifier).moveTask(
              task,
              task.columnId,
              taskMoveGroup.destinationColumnId,
            );
      }
    }
  }
}
