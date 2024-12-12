import 'dart:convert';

import 'package:dart_openai/dart_openai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scrum_assistant/features/changelog/providers/changelog_provider.dart';
import 'package:scrum_assistant/features/chat/models/chat_message.dart';
import 'package:scrum_assistant/features/board/providers/board_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrum_assistant/features/chat/tools/chat_tools.dart';

part 'chat_provider.g.dart';

@Riverpod(keepAlive: true)
class VoiceMode extends _$VoiceMode {
  @override
  bool build() => false;
}

@Riverpod(keepAlive: true)
class ChatNotifier extends _$ChatNotifier {
  bool _isProcessing = false;

  @override
  List<ChatMessage> build() {
    return [];
  }

  Future<void> sendMessage(String content, WidgetRef ref) async {
    if (_isProcessing || content.trim().isEmpty) {
      return;
    }

    try {
      _isProcessing = true;

      state = [
        ...state,
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: content,
          isUser: true,
        ),
      ];

      final boardJson =
          ref.read(boardNotifierProvider.notifier).getBoardAsJson();
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
        tools: ChatTools.getTools(),
      );

      final assistantMessage = chatResponse.choices.first.message;

      if (assistantMessage.haveToolCalls) {
        for (final toolCall in assistantMessage.toolCalls!) {
          await ChatTools.handleToolCall(toolCall: toolCall, ref: ref);
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
                        arguments:
                            jsonDecode(toolCall.function.arguments) ?? {},
                      ))
                  .toList() ??
              [],
        ),
      ];
    } catch (e) {
      state = [
        ...state,
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: 'Ups! Algo salió mal. Intenta nuevamente.',
          isUser: false,
        ),
      ];
      print('Error sending message: $e');
    } finally {
      _isProcessing = false;
    }
  }
}
