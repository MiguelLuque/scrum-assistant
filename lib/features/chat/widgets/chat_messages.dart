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
