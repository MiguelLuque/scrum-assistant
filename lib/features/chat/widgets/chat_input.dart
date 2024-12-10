import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scrum_assistant/features/chat/providers/chat_provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatInput extends HookConsumerWidget {
  const ChatInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = useTextEditingController();
    final speechToText = useMemoized(() => stt.SpeechToText());
    final isListening = useState(false);

    Future<void> startListening() async {
      await speechToText.initialize();
      isListening.value = true;
      speechToText.listen(
        onResult: (result) {
          textController.text = result.recognizedWords;
        },
      );
    }

    Future<void> stopListening() async {
      await speechToText.stop();
      isListening.value = false;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(isListening.value ? Icons.mic_off : Icons.mic),
            onPressed: () {
              if (isListening.value) {
                stopListening();
              } else {
                startListening();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              ref
                  .read(chatNotifierProvider.notifier)
                  .sendMessage(textController.text, ref);
              textController.clear();
            },
          ),
        ],
      ),
    );
  }
}
