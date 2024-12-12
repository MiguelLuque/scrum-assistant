import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scrum_assistant/features/chat/widgets/chat_input.dart';
import 'package:scrum_assistant/features/chat/widgets/chat_messages.dart';

class ChatBottomSheet extends HookConsumerWidget {
  const ChatBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              // Handle bar con diseño más moderno
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              // Header mejorado
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 12, 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.smart_toy_rounded,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Chat Assistant',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: theme.colorScheme.surfaceVariant,
                        padding: const EdgeInsets.all(8),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Divider(
                color: theme.colorScheme.outlineVariant,
                height: 1,
              ),
              // Messages con padding
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ChatMessages(),
                ),
              ),
              // Input con padding
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: ChatInput(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
