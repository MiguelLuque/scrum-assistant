import 'dart:convert';

import 'package:dart_openai/dart_openai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scrum_assistant/features/chat/models/chat_message.dart';
import 'package:scrum_assistant/features/board/providers/board_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    final chatResponse = await OpenAI.instance.chat.create(
      model: "gpt-4o-mini",
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(
              'Here is the current state of the Kanban board in JSON format:\n$boardJson',
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
            description: "Moves a task from one column to another",
            parameters: [
              OpenAIFunctionProperty.integer(
                name: "taskId",
                description: "The ID of the task to move",
              ),
              OpenAIFunctionProperty.integer(
                name: "sourceColumnId",
                description: "The ID of the source column",
              ),
              OpenAIFunctionProperty.integer(
                name: "destinationColumnId",
                description: "The ID of the destination column",
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
          final int taskId = decodedArgs["taskId"];
          final int sourceColumnId = decodedArgs["sourceColumnId"];
          final int destinationColumnId = decodedArgs["destinationColumnId"];

          ref.read(boardNotifierProvider.notifier).moveTaskToColumn(
                taskId,
                sourceColumnId,
                destinationColumnId,
              );
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
