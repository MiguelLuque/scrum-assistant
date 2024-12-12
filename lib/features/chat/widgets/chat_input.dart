import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:scrum_assistant/features/chat/providers/chat_provider.dart';

class ChatInput extends HookConsumerWidget {
  const ChatInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final focusNode = useFocusNode();
    final isComposing = useState(false);
    final theme = Theme.of(context);
    final chatNotifier = ref.watch(chatNotifierProvider.notifier);
    final isVoiceMode = ref.watch(voiceModeProvider);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Botón de voice mode
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: IconButton(
              icon: Icon(
                isVoiceMode
                    ? Icons.volume_up_rounded
                    : Icons.volume_off_rounded,
                color: isVoiceMode
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              style: IconButton.styleFrom(
                backgroundColor: isVoiceMode
                    ? theme.colorScheme.primaryContainer
                    : Colors.transparent,
              ),
              onPressed: () =>
                  ref.read(voiceModeProvider.notifier).switchVoiceMode(),
            ),
          ),
          // Campo de texto expandible
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              minLines: 1,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              style: theme.textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (text) {
                isComposing.value = text.isNotEmpty;
              },
              onSubmitted: (text) {
                if (text.isNotEmpty) {
                  _handleSubmit(text, controller, chatNotifier, ref);
                }
              },
            ),
          ),
          // Botón de enviar animado
          AnimatedScale(
            scale: isComposing.value ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: AnimatedOpacity(
              opacity: isComposing.value ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: IconButton.filled(
                  icon: const Icon(Icons.send_rounded, size: 20),
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    minimumSize: const Size(40, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.all(8),
                  ).copyWith(
                    foregroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return theme.colorScheme.onPrimary.withOpacity(0.8);
                      }
                      return theme.colorScheme.onPrimary;
                    }),
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return theme.colorScheme.primary.withOpacity(0.8);
                      }
                      return theme.colorScheme.primary;
                    }),
                  ),
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      _handleSubmit(
                        controller.text,
                        controller,
                        chatNotifier,
                        ref,
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  void _handleSubmit(
    String text,
    TextEditingController controller,
    ChatNotifier chatNotifier,
    WidgetRef ref,
  ) {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty) return;

    chatNotifier.sendMessage(trimmedText, ref);
    controller.clear();
  }
}
