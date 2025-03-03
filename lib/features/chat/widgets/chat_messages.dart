import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scrum_assistant/features/chat/providers/chat_provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:scrum_assistant/features/chat/widgets/typing_indicator.dart';

class ChatMessages extends HookConsumerWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(chatNotifierProvider);
    final isTyping = ref.watch(chatNotifierProvider.notifier).isTyping;
    final tts = useMemoized(() => FlutterTts());
    final isVoiceMode = ref.watch(voiceModeProvider);
    final scrollController = useScrollController();
    final theme = Theme.of(context);

    // Efecto para auto-scroll al último mensaje cuando se agrega uno nuevo
    // useEffect(() {
    //   if (messages.isNotEmpty) {
    //     Future.delayed(const Duration(milliseconds: 100), () {
    //       scrollController.animateTo(
    //         0, // Desplazarse al inicio de la lista (último mensaje)
    //         duration: const Duration(milliseconds: 200),
    //         curve: Curves.easeOut,
    //       );
    //     });
    //   }
    //   return null;
    // }, [messages.length]);

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

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            reverse:
                true, // Invertir la lista para mostrar los mensajes más recientes primero
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[messages.length -
                  1 -
                  index]; // Obtener el mensaje en orden inverso
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
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                          border: !isUser
                              ? Border.all(
                                  color: theme.colorScheme.outline
                                      .withOpacity(0.3),
                                  width: 1,
                                )
                              : null,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildMessageContent(
                                message.content, isUser, theme),
                            if (message.hasToolCalls) ...[
                              const SizedBox(height: 4),
                              Text(
                                '🛠 ${message.toolCalls.length} tool calls',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isUser
                                      ? theme.colorScheme.onPrimary
                                          .withOpacity(0.7)
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
          ),
        ),
        // Mostrar el indicador de escritura cuando el bot está procesando
        if (isTyping)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildAvatar(false, theme),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(3, (index) {
                      return _buildTypingDot(index, theme);
                    }),
                  ),
                ),
              ],
            ),
          ),
      ],
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

  Widget _buildMessageContent(String content, bool isUser, ThemeData theme) {
    // Detectar si el contenido tiene bloques de código
    if (content.contains('```')) {
      return _buildFormattedContent(content, isUser, theme);
    }

    return SelectableText(
      content,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: isUser
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildFormattedContent(String content, bool isUser, ThemeData theme) {
    return MarkdownBody(
      data: content,
      selectable: true,
      styleSheet: MarkdownStyleSheet(
        p: theme.textTheme.bodyLarge?.copyWith(
          color: isUser
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.onSurfaceVariant,
        ),
        code: theme.textTheme.bodyMedium?.copyWith(
          backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
          fontFamily: 'monospace',
        ),
        codeblockDecoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      builders: {
        'code': CustomCodeBlockBuilder(
          textColor: theme.colorScheme.onSurfaceVariant,
        ),
      },
    );
  }

  Widget _buildTypingDot(int index, ThemeData theme) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 500),
      curve: Interval(index * 0.2, 0.6 + index * 0.2, curve: Curves.easeInOut),
      builder: (context, value, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: 8,
          height: 8 + (8 * (1 - value)),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.7 - (0.2 * index)),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      },
    );
  }
}

class CustomCodeBlockBuilder extends MarkdownElementBuilder {
  final Color textColor;

  CustomCodeBlockBuilder({required this.textColor});

  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    if (element.tag == 'code') {
      String language = '';
      String code = element.textContent;

      // Extraer el lenguaje si está especificado
      if (element.textContent.contains('\n')) {
        final firstLine = element.textContent.split('\n').first;
        if (firstLine.startsWith('```')) {
          language = firstLine.substring(3).trim();
          code = element.textContent
              .substring(firstLine.length + 1)
              .replaceAll('```', '')
              .trim();
        }
      }

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color:
              const Color(0xFF282C34), // Color de fondo del tema Atom One Dark
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: HighlightView(
            code,
            language: language.isEmpty ? 'dart' : language,
            theme: atomOneDarkTheme,
            padding: const EdgeInsets.all(12),
            textStyle: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 14,
            ),
          ),
        ),
      );
    }
    return null;
  }
}
