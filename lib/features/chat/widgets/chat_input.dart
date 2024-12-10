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
    final textController = useTextEditingController();
    final stt = useMemoized(() => SpeechToText(), []);
    final isListening = useState(false);
    final hasInitialized = useState(false);

    Future<void> initializeSpeech() async {
      if (!hasInitialized.value) {
        hasInitialized.value = await stt.initialize();
      }
    }

    Future<void> startListening() async {
      await initializeSpeech();
      if (hasInitialized.value && !isListening.value) {
        isListening.value = true;
        await stt.listen(
          onResult: (result) {
            if (result.finalResult) {
              textController.text = result.recognizedWords;
              // Solo enviar el mensaje cuando el resultado es final
              if (textController.text.isNotEmpty) {
                ref
                    .read(chatNotifierProvider.notifier)
                    .sendMessage(textController.text, ref);
                textController.clear();
              }
              isListening.value = false;
            }
          },
        );
      }
    }

    Future<void> stopListening() async {
      if (isListening.value) {
        await stt.stop();
        isListening.value = false;
      }
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
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              isListening.value ? Icons.mic_off : Icons.mic,
              color: isListening.value ? Colors.red : null,
            ),
            onPressed: isListening.value ? stopListening : startListening,
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              if (textController.text.isNotEmpty) {
                ref
                    .read(chatNotifierProvider.notifier)
                    .sendMessage(textController.text, ref);
                textController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
