import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scrum_assistant/data/repositories/board_local_repository.dart';
import 'package:scrum_assistant/features/board/models/column_model.dart';
import 'package:scrum_assistant/features/board/providers/board_provider.dart';

part 'board_persistence_provider.g.dart';

/// ID del tablero actual (en una aplicación real, podría haber múltiples tableros)
const String currentBoardId = 'current_board';

/// Provider para el repositorio local de tableros
@riverpod
BoardLocalRepository boardLocalRepository(BoardLocalRepositoryRef ref) {
  return BoardLocalRepository();
}

/// Provider para gestionar la persistencia del tablero
@Riverpod(keepAlive: true)
class BoardPersistenceNotifier extends _$BoardPersistenceNotifier {
  @override
  Future<void> build() async {
    // Inicializar el repositorio
    final repository = ref.read(boardLocalRepositoryProvider);
    await repository.initialize();

    // Cargar datos iniciales
    await _loadInitialData();

    // Observar cambios en el estado del tablero para guardarlos automáticamente
    ref.listen(boardNotifierProvider, (previous, next) {
      if (previous != next) {
        _saveCurrentBoard(next);
      }
    });
  }

  /// Carga datos iniciales del almacenamiento local si existen
  Future<void> _loadInitialData() async {
    try {
      final repository = ref.read(boardLocalRepositoryProvider);
      final columns = await repository.getBoard();

      // Si ya hay un tablero guardado, actualizamos el estado
      if (columns != null && columns.isNotEmpty) {
        // Actualizar el estado del tablero con los datos persistidos
        ref.read(boardNotifierProvider.notifier).state = columns;
      } else {
        // Si no hay datos, guardamos el estado inicial
        final columns = ref.read(boardNotifierProvider);
        await _saveCurrentBoard(columns);
      }
    } catch (e) {
      // Manejar errores: podríamos mostrar un mensaje o intentar recuperarse
      print('Error loading initial data: $e');
    }
  }

  /// Guarda el estado actual del tablero
  Future<void> _saveCurrentBoard(List<ColumnModel> columns) async {
    try {
      final repository = ref.read(boardLocalRepositoryProvider);

      // Guardar en el almacenamiento local
      await repository.saveBoard(columns);
    } catch (e) {
      // Manejar errores: podríamos mostrar un mensaje o intentar recuperarse
      print('Error saving board: $e');
    }
  }

  /// Fuerza una recarga de los datos desde la persistencia local
  Future<void> reloadFromPersistence() async {
    // Invalidar el estado actual para reconstruirlo
    ref.invalidateSelf();
    // Esperar a que se reconstruya
    await future;
  }

  /// Limpia todos los datos persistidos
  Future<void> clearAllData() async {
    try {
      final repository = ref.read(boardLocalRepositoryProvider);
      await repository.clearAllData();

      // Recargar datos (que serán los valores iniciales del provider)
      await reloadFromPersistence();
    } catch (e) {
      print('Error clearing data: $e');
    }
  }
}
