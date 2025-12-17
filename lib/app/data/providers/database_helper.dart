import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:moodgrid/app/data/models/daily_record.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  // Nombre de la base de datos y tabla
  static const String _databaseName = 'moodgrid.db';
  static const int _databaseVersion = 1;
  static const String _tableName = 'daily_records';

  // Obtener la instancia de la base de datos
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inicializar la base de datos
  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // Crear la tabla
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL UNIQUE,
        color_index INTEGER NOT NULL,
        comment TEXT
      )
    ''');
  }

  // ==================== CRUD Operations ====================

  // Insertar un nuevo registro
  Future<int> insertRecord(DailyRecord record) async {
    final db = await database;
    try {
      return await db.insert(
        _tableName,
        record.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Error al insertar registro: $e');
    }
  }

  // Obtener un registro por fecha
  Future<DailyRecord?> getRecordByDate(DateTime date) async {
    final db = await database;
    final dateString = date.toIso8601String().split('T')[0];

    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'date = ?',
      whereArgs: [dateString],
    );

    if (maps.isEmpty) return null;
    return DailyRecord.fromMap(maps.first);
  }

  // Obtener todos los registros
  Future<List<DailyRecord>> getAllRecords() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) {
      return DailyRecord.fromMap(maps[i]);
    });
  }

  // Obtener registros en un rango de fechas
  Future<List<DailyRecord>> getRecordsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await database;
    final startDateString = startDate.toIso8601String().split('T')[0];
    final endDateString = endDate.toIso8601String().split('T')[0];

    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'date BETWEEN ? AND ?',
      whereArgs: [startDateString, endDateString],
      orderBy: 'date ASC',
    );

    return List.generate(maps.length, (i) {
      return DailyRecord.fromMap(maps[i]);
    });
  }

  // Actualizar un registro
  Future<int> updateRecord(DailyRecord record) async {
    final db = await database;
    try {
      return await db.update(
        _tableName,
        record.toMap(),
        where: 'id = ?',
        whereArgs: [record.id],
      );
    } catch (e) {
      throw Exception('Error al actualizar registro: $e');
    }
  }

  // Eliminar un registro
  Future<int> deleteRecord(int id) async {
    final db = await database;
    try {
      return await db.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Error al eliminar registro: $e');
    }
  }

  // Eliminar un registro por fecha
  Future<int> deleteRecordByDate(DateTime date) async {
    final db = await database;
    final dateString = date.toIso8601String().split('T')[0];
    try {
      return await db.delete(
        _tableName,
        where: 'date = ?',
        whereArgs: [dateString],
      );
    } catch (e) {
      throw Exception('Error al eliminar registro: $e');
    }
  }

  // Eliminar todos los registros
  Future<int> deleteAllRecords() async {
    final db = await database;
    try {
      return await db.delete(_tableName);
    } catch (e) {
      throw Exception('Error al eliminar todos los registros: $e');
    }
  }

  // ==================== Import/Export Operations ====================

  // Exportar a JSON
  Future<String> exportToJson() async {
    try {
      final records = await getAllRecords();
      final jsonList = records.map((record) => record.toJson()).toList();

      final jsonString = jsonEncode({
        'version': _databaseVersion,
        'export_date': DateTime.now().toIso8601String(),
        'records': jsonList,
      });

      return jsonString;
    } catch (e) {
      throw Exception('Error al exportar datos: $e');
    }
  }

  // Guardar backup en archivo
  Future<File> saveBackupToFile() async {
    try {
      final jsonString = await exportToJson();
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final file = File('${directory.path}/backup_mood_$timestamp.json');
      return await file.writeAsString(jsonString);
    } catch (e) {
      throw Exception('Error al guardar backup: $e');
    }
  }

  // Importar desde JSON
  Future<int> importFromJson(String jsonString) async {
    try {
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      final recordsList = jsonData['records'] as List<dynamic>;

      int importedCount = 0;

      for (final recordJson in recordsList) {
        final record = DailyRecord.fromJson(recordJson as Map<String, dynamic>);
        await insertRecord(record);
        importedCount++;
      }

      return importedCount;
    } catch (e) {
      throw Exception('Error al importar datos: $e');
    }
  }

  // Importar desde archivo
  Future<int> importFromFile(File file) async {
    try {
      final jsonString = await file.readAsString();
      return await importFromJson(jsonString);
    } catch (e) {
      throw Exception('Error al importar desde archivo: $e');
    }
  }

  // ==================== Statistics ====================

  // Obtener conteo total de registros
  Future<int> getTotalRecordsCount() async {
    final db = await database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $_tableName'),
    );
    return count ?? 0;
  }

  // Obtener estadísticas de estados de ánimo
  Future<Map<int, int>> getMoodStatistics() async {
    final records = await getAllRecords();
    final Map<int, int> statistics = {
      0: 0, // Excelente
      1: 0, // Bien
      2: 0, // Neutral
      3: 0, // Difícil
      4: 0, // Mal
    };

    for (final record in records) {
      if (record.colorIndex >= 0 && record.colorIndex <= 4) {
        statistics[record.colorIndex] = (statistics[record.colorIndex] ?? 0) + 1;
      }
    }

    return statistics;
  }

  // Cerrar la base de datos
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
