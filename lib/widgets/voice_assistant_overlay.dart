import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scrum_assistant/features/chat/models/chat_message.dart';
import 'package:scrum_assistant/features/chat/providers/chat_provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

enum AssistantState {
  idle,
  listening,
  processing,
  speaking,
}

class VoiceAssistantOverlay extends HookConsumerWidget {
  const VoiceAssistantOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assistantState = useState(AssistantState.listening);
    final speechToText = useMemoized(() => stt.SpeechToText(), []);
    final isInitialized = useState(false);
    final recognizedText = useState('');

    // Inicializar STT al montar el widget
    useEffect(() {
      Future.microtask(() async {
        final available = await speechToText.initialize(
          onStatus: (status) {
            // onStatus se llama cuando el estado de STT cambia (ej. listening, notListening)
            if (status == 'notListening' &&
                assistantState.value == AssistantState.listening) {
              // El usuario dejó de hablar
              // Pasar a estado processing
              assistantState.value = AssistantState.processing;
            }
          },
          onError: (error) {
            debugPrint("Error en STT: $error");
            // Podríamos manejar errores cambiando estado a idle o intentando reiniciar
          },
        );
        isInitialized.value = available;
      });
      return null;
    }, []);

    // Escuchar cambios en el estado del chatNotifierProvider
    ref.listen<List<ChatMessage>>(
      chatNotifierProvider,
      (previous, next) {
        if (next.isNotEmpty && !next.last.isUser) {
          assistantState.value = AssistantState.speaking;
        }
      },
    );

    // Efecto al cambiar el estado del asistente
    useEffect(() {
      if (!isInitialized.value) return;

      switch (assistantState.value) {
        case AssistantState.idle:
          // Estado idle: no hacemos nada especial
          break;

        case AssistantState.listening:
          // Iniciamos la escucha si STT está inicializado
          speechToText.listen(
            onResult: (result) {
              recognizedText.value = result.recognizedWords;
              if (result.finalResult) {
                assistantState.value = AssistantState.processing;
              }
            },
            pauseFor: const Duration(seconds: 3),
            partialResults: true,
            localeId: 'es_ES',
          );
          break;

        case AssistantState.processing:
          if (speechToText.isListening) {
            speechToText.stop();
            speechToText.cancel();
          }

          final text = recognizedText.value.trim();
          if (text.isNotEmpty) {
            debugPrint('Enviando mensaje: $text');
            Future.microtask(() {
              ref.read(chatNotifierProvider.notifier).sendMessage(text, ref);
            });
          } else {
            debugPrint('Texto reconocido vacío');
          }

          // Simulamos un tiempo de "procesamiento"
          break;

        case AssistantState.speaking:
          // Simular que el asistente "habla" durante unos segundos.
          Future.microtask(() async {
            await Future.delayed(const Duration(seconds: 3));
            assistantState.value = AssistantState.listening;
          });
          break;
      }

      return null;
    }, [assistantState.value, isInitialized.value]);

    // Widget de UI según estado
    Widget content;
    switch (assistantState.value) {
      case AssistantState.idle:
        content = const SizedBox.shrink();
        break;
      case AssistantState.listening:
        content = const Icon(Icons.mic, size: 100, color: Colors.white);
        break;
      case AssistantState.processing:
        content = const CircularProgressIndicator(color: Colors.white);
        break;
      case AssistantState.speaking:
        content =
            const Icon(Icons.volume_up_rounded, size: 100, color: Colors.white);
        break;
    }

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: Colors.black54,
            child: Center(child: content),
          ),
        ),
      ],
    );
  }
}
