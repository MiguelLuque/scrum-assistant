import 'package:flutter_tts/flutter_tts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:scrum_assistant/features/chat/providers/chat_provider.dart';

part 'voice_assistant.g.dart';

enum AssistantState {
  idle,
  listening,
  processing,
  speaking,
}

@Riverpod(keepAlive: true)
class VoiceAssistant extends _$VoiceAssistant {
  @override
  AssistantState build() {
    return AssistantState.idle;
  }

  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  Future<void> startListening(WidgetRef ref) async {
    await _speechToText.initialize(
      onStatus: (status) => print('Speech-to-Text Status: $status'),
      onError: (error) => {
        print('Speech-to-Text Error: $error'),
        //state = AssistantState.idle,
      },
    );
    await _speechToText.listen(
        partialResults: false,
        cancelOnError: false,
        localeId: 'es_ES',
        pauseFor: const Duration(seconds: 3),
        listenOptions: SpeechListenOptions(
          partialResults: false,
          //cancelOnError: true,
        ),
        onResult: (result) async => {
              _onSpeechResult(result, ref),
              await _speechToText.listen(
                  onResult: (result) => _onSpeechResult(result, ref))
            });
    state = AssistantState.listening;
  }

  Future<void> _onSpeechResult(
      SpeechRecognitionResult result, WidgetRef ref) async {
    if (result.finalResult &&
        result.recognizedWords.isNotEmpty &&
        result.confidence > 0.6) {
      await _speechToText.stop();
      state = AssistantState.processing;
      final userQuery = result.recognizedWords;
      await ref.read(chatNotifierProvider.notifier).sendMessage(userQuery, ref);
      state = AssistantState.speaking;
      final assistantResponse = ref.read(chatNotifierProvider).last.content;
      await _flutterTts.setLanguage('es-ES');
      await _flutterTts.speak(assistantResponse);
      state = AssistantState.listening;
    }
  }

  Future<void> stopListening() async {
    await _speechToText.cancel();
    await _flutterTts.stop();
    state = AssistantState.idle;
  }
}
