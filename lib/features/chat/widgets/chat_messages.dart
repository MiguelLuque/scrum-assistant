import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scrum_assistant/features/chat/providers/chat_provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ChatMessages extends HookConsumerWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(chatNotifierProvider);
    final tts = useMemoized(() => FlutterTts());
    final isVoiceMode = ref.watch(voiceModeProvider);
    final scrollController = useScrollController();
    final theme = Theme.of(context);

    // Efecto para auto-scroll
    useEffect(() {
      if (messages.isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 100), () {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        });
      }
      return null;
    }, [messages.length]);

    // Efecto para TTS
    useEffect(() {
      final subscription =
          ref.listenManual(chatNotifierProvider, (previous, next) {
        if (isVoiceMode &&
            next.isNotEmpty &&
            previous != null &&
            next.length > previous.length &&
            !next.last.isUser) {
          tts.speak(next.last.content);
        }
      });
      return subscription.close;
    }, [isVoiceMode]);

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isUser = message.isUser;

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          child: Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isUser) _buildAvatar(isUser, theme),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  decoration: BoxDecoration(
                    color: isUser
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isUser ? 20 : 5),
                      bottomRight: Radius.circular(isUser ? 5 : 20),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        message.content,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: isUser
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (message.hasToolCalls) ...[
                        const SizedBox(height: 4),
                        Text(
                          '🛠 ${message.toolCalls.length} tool calls',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isUser
                                ? theme.colorScheme.onPrimary.withOpacity(0.7)
                                : theme.colorScheme.onSurfaceVariant
                                    .withOpacity(0.7),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (isUser) _buildAvatar(isUser, theme),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAvatar(bool isUser, ThemeData theme) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isUser
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.secondaryContainer,
        shape: BoxShape.circle,
      ),
      child: Icon(
        isUser ? Icons.person_rounded : Icons.smart_toy_rounded,
        size: 16,
        color: isUser
            ? theme.colorScheme.onPrimaryContainer
            : theme.colorScheme.onSecondaryContainer,
      ),
    );
  }
}
