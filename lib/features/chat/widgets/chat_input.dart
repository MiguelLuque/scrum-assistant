import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
    final isTyping = chatNotifier.isTyping;

    return Row(
      children: [
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
            enabled: !isTyping,
            decoration: InputDecoration(
              hintText:
                  isTyping ? 'Waiting for response...' : 'Type a message...',
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
              if (text.isNotEmpty && !isTyping) {
                _handleSubmit(text, controller, chatNotifier, ref);
              }
            },
          ),
        ),
        // Botón de enviar animado
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: IconButton.filled(
            icon: const Icon(Icons.send_rounded, size: 20),
            style: IconButton.styleFrom(
              backgroundColor: isTyping || !isComposing.value
                  ? theme.colorScheme.primary.withOpacity(0.5)
                  : theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              minimumSize: const Size(40, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              padding: const EdgeInsets.all(8),
            ),
            onPressed: (isTyping || !isComposing.value)
                ? null // Deshabilitar cuando está escribiendo
                : () {
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
        const SizedBox(width: 8),
      ],
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
