import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrum_assistant/features/chat/tools/move_task_tool.dart';
import 'package:scrum_assistant/features/chat/tools/create_task_tool.dart';
import 'package:scrum_assistant/features/chat/tools/delete_task_tool.dart';
import 'package:scrum_assistant/features/chat/tools/update_task_tool.dart';

class ChatTools {
  static List<OpenAIToolModel> getTools() {
    return [
      MoveTaskTool.definition(),
      CreateTaskTool.definition(),
      DeleteTaskTool.definition(),
      UpdateTaskTool.definition(),
    ];
  }

  static Future<void> handleToolCall({
    required OpenAIResponseToolCall toolCall,
    required WidgetRef ref,
  }) async {
    switch (toolCall.function.name) {
      case "moveTask":
        await MoveTaskTool.execute(toolCall: toolCall, ref: ref);
        break;
      case "createTasks":
        await CreateTaskTool.execute(toolCall: toolCall, ref: ref);
        break;
      case "deleteTasks":
        await DeleteTaskTool.execute(toolCall: toolCall, ref: ref);
        break;
      case "updateTasks":
        await UpdateTaskTool.execute(toolCall: toolCall, ref: ref);
        break;
      default:
        throw Exception(
          'Unknown tool call: ${toolCall.function.name}',
        );
    }
  }
}
