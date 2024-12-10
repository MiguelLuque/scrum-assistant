import 'dart:convert';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrum_assistant/features/board/providers/board_provider.dart';

class UpdateTaskTool {
  static OpenAIToolModel definition() {
    return OpenAIToolModel(
      type: "function",
      function: OpenAIFunctionModel.withParameters(
        name: "updateTasks",
        description: "Updates one or more existing tasks",
        parameters: [
          OpenAIFunctionProperty.array(
            name: "tasks",
            description: "A list of tasks to update",
            items: OpenAIFunctionProperty.object(
              name: "task",
              properties: [
                OpenAIFunctionProperty.integer(
                  name: "id",
                  description: "The ID of the task to update",
                  isRequired: true,
                ),
                OpenAIFunctionProperty.string(
                  name: "title",
                  description: "The new title of the task",
                  isRequired: false,
                ),
                OpenAIFunctionProperty.integer(
                  name: "columnId",
                  description: "The column ID where the task is located",
                  isRequired: true,
                ),
                OpenAIFunctionProperty.string(
                  name: "description",
                  description: "The new description of the task",
                  isRequired: false,
                ),
                OpenAIFunctionProperty.array(
                  name: "labels",
                  description: "The new labels for the task",
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
    final List<dynamic> tasksToUpdate = decodedArgs["tasks"];

    for (final taskJson in tasksToUpdate) {
      // Obtener la tarea actual
      final currentTask = ref
          .read(boardNotifierProvider)
          .firstWhere((column) => column.id == taskJson["columnId"])
          .tasks
          .firstWhere((task) => task.id == taskJson["id"]);

      // Crear la tarea actualizada manteniendo los valores existentes si no se proporcionan nuevos
      final updatedTask = currentTask.copyWith(
        title: taskJson["title"] ?? currentTask.title,
        description: taskJson["description"] ?? currentTask.description,
        labels: (taskJson["labels"] as List<dynamic>?)?.cast<String>() ??
            currentTask.labels,
        isCompleted: taskJson["isCompleted"] ?? currentTask.isCompleted,
      );

      // Actualizar la tarea
      ref.read(boardNotifierProvider.notifier).updateTask(updatedTask);
    }
  }
}
