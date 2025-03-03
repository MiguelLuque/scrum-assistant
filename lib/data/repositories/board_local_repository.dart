import 'package:scrum_assistant/data/local/hive_adapters.dart';
import 'package:scrum_assistant/features/board/models/board_model.dart';
import 'package:scrum_assistant/features/board/models/column_model.dart';
import 'package:scrum_assistant/features/board/models/task_model.dart';

/// Repositorio para gestionar los datos locales de los tableros usando Hive
class BoardLocalRepository {
  /// Instancia compartida del repositorio (patrón Singleton)
  static final BoardLocalRepository _instance =
      BoardLocalRepository._internal();

  /// Método fábrica para garantizar una única instancia
  factory BoardLocalRepository() => _instance;

  /// Constructor privado para el singleton
  BoardLocalRepository._internal();

  /// Inicializa el repositorio obteniendo las referencias a las cajas
  Future<void> initialize() async {
    try {
      // Aseguramos que Hive esté inicializado
      await HiveService.initialize();
    } catch (e) {
      throw Exception('Error initializing board repository: $e');
    }
  }

  /// Guarda un tablero completo con sus columnas y tareas
  Future<void> saveBoard(List<ColumnModel> columns) async {
    try {
      await HiveService.saveBoard(columns);
    } catch (e) {
      throw Exception('Error saving board: $e');
    }
  }

  /// Obtiene las columnas del tablero
  Future<List<ColumnModel>?> getBoard() async {
    try {
      return await HiveService.loadBoard();
    } catch (e) {
      throw Exception('Error getting board: $e');
    }
  }

  /// Limpia todos los datos persistidos
  Future<void> clearAllData() async {
    try {
      await HiveService.clearAllData();
    } catch (e) {
      throw Exception('Error clearing data: $e');
    }
  }

  /// Cierra las cajas y libera recursos
  Future<void> close() async {
    await HiveService.close();
  }
}
