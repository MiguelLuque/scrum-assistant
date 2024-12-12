import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

enum AssistantState {
  idle,
  listening,
  processing,
  speaking,
}

class VoiceAssistantOverlay extends HookConsumerWidget {
  const VoiceAssistantOverlay({super.key});

  Future<void> loopStates(ValueNotifier<AssistantState> state) async {
    while (true) {
      if (state.value == AssistantState.idle)
        break; // Salir del bucle si se cierra el overlay

      // Estado: Escuchando
      state.value = AssistantState.listening;
      await Future.delayed(const Duration(seconds: 3)); // Simulación de escucha

      // Estado: Procesando
      state.value = AssistantState.processing;
      await Future.delayed(
          const Duration(seconds: 2)); // Simulación de procesamiento

      // Estado: Hablando
      state.value = AssistantState.speaking;
      await Future.delayed(const Duration(seconds: 3)); // Simulación de habla
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //usestate
    final assistantState = useState(AssistantState.listening);
    
    final speechToText = useMemoized(() => stt.SpeechToText(), []);
    final isInitialized = useState(false);
    final recognizedText = useState('');

    // Ejecutar la lógica al mostrar el widget
    useEffect(() {
      // Llama a `startListening` cuando el widget se muestra
      loopStates(assistantState);
      return null; // No necesita limpiar recursos en este caso
    }, []); // El array vacío asegura que solo se ejecute una vez al montar

    Widget content;
    switch (assistantState.value) {
      case AssistantState.idle:
        content = Container();
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
