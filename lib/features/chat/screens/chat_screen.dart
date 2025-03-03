import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scrum_assistant/features/chat/providers/chat_provider.dart';
import 'package:scrum_assistant/features/chat/widgets/typing_indicator.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:markdown/markdown.dart' as md;

class ChatScreen extends HookConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(chatNotifierProvider);
    final isTyping = ref.watch(chatNotifierProvider.notifier).isTyping;
    final textController = useTextEditingController();
    final theme = Theme.of(context);

    // ScrollController para manejar el desplazamiento
    final scrollController = useScrollController();

    // Efecto para desplazarse hacia abajo cuando hay nuevos mensajes
    useEffect(() {
      if (messages.isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (scrollController.hasClients) {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          }
        });
      }
      return null;
    }, [messages.length]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatGPT'),
        elevation: 2,
        backgroundColor: theme.colorScheme.surface,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              itemCount: messages.length + (isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == messages.length) {
                  return const TypingIndicator();
                }
                final message = messages[index];
                final isUser = message.isUser;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: isUser
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: isTyping
                          ? 'Esperando respuesta...'
                          : 'Escribe un mensaje...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        borderSide: BorderSide(
                          color: theme.colorScheme.outline,
                          width: 1.0,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                    ),
                    enabled: !isTyping,
                    onSubmitted: (text) {
                      if (text.trim().isNotEmpty && !isTyping) {
                        ref
                            .read(chatNotifierProvider.notifier)
                            .sendMessage(text, ref);
                        textController.clear();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: const Icon(Icons.send_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor:
                        isTyping || textController.text.trim().isEmpty
                            ? theme.colorScheme.primary.withOpacity(0.5)
                            : theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    shape: const CircleBorder(),
                  ),
                  onPressed: isTyping
                      ? null
                      : () {
                          if (textController.text.trim().isNotEmpty) {
                            ref
                                .read(chatNotifierProvider.notifier)
                                .sendMessage(textController.text, ref);
                            textController.clear();
                          }
                        },
                ),
              ],
            ),
          ),
        ],
      ),
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
