import 'package:hive_flutter/hive_flutter.dart';
import 'package:scrum_assistant/features/board/models/task_model.dart';
import 'package:scrum_assistant/features/board/models/column_model.dart';
import 'package:scrum_assistant/features/board/models/board_model.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

/// Clase que gestiona la inicialización y registro de adaptadores para Hive
class HiveService {
  /// Flag para evitar múltiples inicializaciones
  static bool _initialized = false;

  /// Nombres de las cajas (boxes) de Hive
  static const String boardsBoxName = 'boards';
  static const String columnsBoxName = 'columns';
  static const String tasksBoxName = 'tasks';
  static const String boardDataBoxName = 'board_data';

  /// Inicializa Hive y registra los adaptadores necesarios
  static Future<void> initialize() async {
    if (_initialized) return;

    // Obtenemos el directorio de documentos para almacenar las cajas de Hive
    final appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);

    // Usamos un enfoque más simple: almacenamos cadenas JSON en lugar de objetos directos
    await Hive.openBox<String>(boardDataBoxName);

    _initialized = true;
  }

  /// Guarda un tablero como JSON en Hive
  static Future<void> saveBoard(List<ColumnModel> columns) async {
    if (!_initialized) await initialize();

    // Convertimos la lista de columnas a JSON
    final boardBox = Hive.box<String>(boardDataBoxName);

    // Convertir cada columna a un mapa, y luego a JSON
    final List<Map<String, dynamic>> columnsJson =
        columns.map((column) => column.toJson()).toList();
    final String jsonData = jsonEncode(columnsJson);

    // Guardar con una clave fija
    await boardBox.put('current_board', jsonData);
  }

  /// Carga un tablero desde JSON en Hive
  static Future<List<ColumnModel>?> loadBoard() async {
    if (!_initialized) await initialize();

    final boardBox = Hive.box<String>(boardDataBoxName);
    final String? jsonData = boardBox.get('current_board');

    if (jsonData == null) return null;

    try {
      // Decodificar el JSON y convertirlo a una lista de ColumnModel
      final List<dynamic> columnsJson = jsonDecode(jsonData);
      final List<ColumnModel> columns = columnsJson
          .map((json) => ColumnModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return columns;
    } catch (e) {
      print('Error loading board data: $e');
      return null;
    }
  }

  /// Limpia todos los datos almacenados
  static Future<void> clearAllData() async {
    if (!_initialized) await initialize();

    final boardBox = Hive.box<String>(boardDataBoxName);
    await boardBox.clear();
  }

  /// Método para cerrar todas las cajas y limpiar recursos
  static Future<void> close() async {
    await Hive.close();
    _initialized = false;
  }
}

/// Adaptador personalizado para TaskModel
class TaskModelAdapter extends TypeAdapter<TaskModel> {
  @override
  final int typeId = 1;

  @override
  TaskModel read(BinaryReader reader) {
    return TaskModel.fromJson(reader.readMap().cast<String, dynamic>());
  }

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer.writeMap(obj.toJson());
  }
}

/// Adaptador personalizado para ColumnModel
class ColumnModelAdapter extends TypeAdapter<ColumnModel> {
  @override
  final int typeId = 2;

  @override
  ColumnModel read(BinaryReader reader) {
    return ColumnModel.fromJson(reader.readMap().cast<String, dynamic>());
  }

  @override
  void write(BinaryWriter writer, ColumnModel obj) {
    writer.writeMap(obj.toJson());
  }
}

/// Adaptador personalizado para BoardModel
class BoardModelAdapter extends TypeAdapter<BoardModel> {
  @override
  final int typeId = 3;

  @override
  BoardModel read(BinaryReader reader) {
    return BoardModel.fromJson(reader.readMap().cast<String, dynamic>());
  }

  @override
  void write(BinaryWriter writer, BoardModel obj) {
    writer.writeMap(obj.toJson());
  }
}
