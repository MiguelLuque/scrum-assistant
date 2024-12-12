import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scrum_assistant/providers/voice_assistant.dart';

class VoiceAssistantOverlay extends HookConsumerWidget {
  const VoiceAssistantOverlay({super.key});

  Widget _ListeningAnimation() {
    return const Text('Listening...');
    //const CircularProgressIndicator();
  }

  Widget _ProcessingAnimation() {
    return const CircularProgressIndicator();
  }

  Widget _SpeakingAnimation() {
    return const Text('Speaking...');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assistantState = ref.watch(voiceAssistantProvider);

    Widget content;
    switch (assistantState) {
      case AssistantState.idle:
        content = Container();
        break;
      case AssistantState.listening:
        content = _ListeningAnimation();
        break;
      case AssistantState.processing:
        content = _ProcessingAnimation();
        break;
      case AssistantState.speaking:
        content = _SpeakingAnimation();
        break;
    }

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              ref.read(voiceAssistantProvider.notifier).stopListening();
            },
            child: Container(color: Colors.black54),
          ),
        ),
        Center(child: content),
      ],
    );
  }
}
