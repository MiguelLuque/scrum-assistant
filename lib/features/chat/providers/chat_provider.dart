import 'dart:convert';

import 'package:dart_openai/dart_openai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scrum_assistant/features/changelog/providers/changelog_provider.dart';
import 'package:scrum_assistant/features/chat/models/chat_message.dart';
import 'package:scrum_assistant/features/board/providers/board_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrum_assistant/features/chat/models/task_move_group.dart';

part 'chat_provider.g.dart';

@riverpod
class ChatNotifier extends _$ChatNotifier {
  @override
  List<ChatMessage> build() {
    return [];
  }

  Future<void> sendMessage(String content, WidgetRef ref) async {
    state = [
      ...state,
      ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content,
        isUser: true,
      ),
    ];

    final boardJson = ref.read(boardNotifierProvider.notifier).getBoardAsJson();
    final changelogJson =
        ref.read(changelogNotifierProvider.notifier).getChangelogAsJson();

    final chatResponse = await OpenAI.instance.chat.create(
      model: "gpt-4o-mini",
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(
              'Here is the current state of the Kanban board in JSON format:\n$boardJson\n\n'
              'And here is the changelog of the Kanban board in JSON format:\n$changelogJson',
            ),
          ],
          role: OpenAIChatMessageRole.system,
        ),
        ...state.map((message) {
          return OpenAIChatCompletionChoiceMessageModel(
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(
                message.content,
              ),
            ],
            role: message.isUser
                ? OpenAIChatMessageRole.user
                : OpenAIChatMessageRole.assistant,
          );
        }),
      ],
      tools: [
        // Define your tools here
        OpenAIToolModel(
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
                      items: OpenAIFunctionProperty.integer(
                        name: "taskId",
                        description: "The ID of the task to move",
                      ),
                    ),
                    OpenAIFunctionProperty.integer(
                      name: "destinationColumnId",
                      description: "The ID of the destination column",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );

    final assistantMessage = chatResponse.choices.first.message;

    if (assistantMessage.haveToolCalls) {
      for (final toolCall in assistantMessage.toolCalls!) {
        if (toolCall.function.name == "exampleTool") {
          final input = toolCall.function.arguments["input"];
          // Handle the tool call based on the input
          // ...
        }
        if (toolCall.function.name == "moveTask") {
          final decodedArgs = jsonDecode(toolCall.function.arguments);
          final List<dynamic> taskMoveGroupsJson =
              decodedArgs["taskMoveGroups"];

          final List<TaskMoveGroup> taskMoveGroups =
              taskMoveGroupsJson.map((json) {
            return TaskMoveGroup(
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
    }

    state = [
      ...state,
      ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: assistantMessage.content?.first.text ?? '',
        isUser: false,
        hasToolCalls: assistantMessage.haveToolCalls,
        toolCalls: assistantMessage.toolCalls
                ?.map((toolCall) => OpenAIToolCall(
                      name: toolCall.function.name ?? '',
                      arguments: jsonDecode(toolCall.function.arguments) ?? {},
                    ))
                .toList() ??
            [],
      ),
    ];
  }
}
