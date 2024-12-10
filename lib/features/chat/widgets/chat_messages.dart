import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scrum_assistant/features/chat/providers/chat_provider.dart';

class ChatMessages extends HookConsumerWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(chatNotifierProvider);

    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return ListTile(
          title: Text(message.content),
          subtitle: message.hasToolCalls
              ? Text('Tool calls: ${message.toolCalls.length}')
              : null,
          trailing: message.isUser
              ? const Icon(Icons.person)
              : const Icon(Icons.smart_toy),
        );
      },
    );
  }
} 