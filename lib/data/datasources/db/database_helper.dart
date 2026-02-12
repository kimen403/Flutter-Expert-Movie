import 'dart:async';
import 'package:hive/hive.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  DatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

  // Cache untuk menyimpan box yang sudah dibuka
  static final Map<String, Box<Map>> _boxes = {};

  /// Mendapatkan atau membuka box berdasarkan boxName
  Future<Box<Map>> _getBox(String boxName) async {
    if (_boxes[boxName] == null || !_boxes[boxName]!.isOpen) {
      _boxes[boxName] = await Hive.openBox<Map>(boxName);
    }
    return _boxes[boxName]!;
  }

  /// Insert data ke box dengan key tertentu
  ///
  /// [boxName] - Nama box/tabel
  /// [key] - Key untuk data (bisa String atau int)
  /// [data] - Data yang akan disimpan (Map atau object dengan toJson())
  Future<bool> insert(String boxName, dynamic key, dynamic data) async {
    try {
      final box = await _getBox(boxName);

      Map<String, dynamic> dataMap;
      if (data is Map<String, dynamic>) {
        dataMap = data;
      } else if (data.toJson != null) {
        dataMap = data.toJson();
      } else {
        throw ArgumentError(
            'Data harus berupa Map atau object dengan method toJson()');
      }

      await box.put(key, dataMap);
      return true;
    } catch (e) {
      print('Error inserting data: $e');
      return false;
    }
  }

  /// Update data (sama dengan insert di Hive)
  Future<bool> update(String boxName, dynamic key, dynamic data) async {
    return await insert(boxName, key, data);
  }

  /// Get data berdasarkan key
  ///
  /// [boxName] - Nama box/tabel
  /// [key] - Key data yang dicari
  Future<Map<String, dynamic>?> getByKey(String boxName, dynamic key) async {
    try {
      final box = await _getBox(boxName);
      final result = box.get(key);

      if (result != null) {
        return Map<String, dynamic>.from(result);
      }
      return null;
    } catch (e) {
      print('Error getting data by key: $e');
      return null;
    }
  }

  /// Get semua data dari box
  ///
  /// [boxName] - Nama box/tabel
  Future<List<Map<String, dynamic>>> getAll(String boxName) async {
    try {
      final box = await _getBox(boxName);
      final List<Map<String, dynamic>> results = [];

      for (var value in box.values) {
        results.add(Map<String, dynamic>.from(value));
      }

      return results;
    } catch (e) {
      print('Error getting all data: $e');
      return [];
    }
  }

  /// Get semua data dengan key-value pair
  ///
  /// [boxName] - Nama box/tabel
  Future<Map<dynamic, Map<String, dynamic>>> getAllWithKeys(
      String boxName) async {
    try {
      final box = await _getBox(boxName);
      final Map<dynamic, Map<String, dynamic>> results = {};

      for (var key in box.keys) {
        final value = box.get(key);
        if (value != null) {
          results[key] = Map<String, dynamic>.from(value);
        }
      }

      return results;
    } catch (e) {
      print('Error getting all data with keys: $e');
      return {};
    }
  }

  /// Delete data berdasarkan key
  ///
  /// [boxName] - Nama box/tabel
  /// [key] - Key data yang akan dihapus
  Future<bool> delete(String boxName, dynamic key) async {
    try {
      final box = await _getBox(boxName);
      if (box.containsKey(key)) {
        await box.delete(key);
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting data: $e');
      return false;
    }
  }

  /// Delete multiple data berdasarkan list keys
  ///
  /// [boxName] - Nama box/tabel
  /// [keys] - List keys yang akan dihapus
  Future<int> deleteMultiple(String boxName, List<dynamic> keys) async {
    try {
      final box = await _getBox(boxName);
      int deletedCount = 0;

      for (var key in keys) {
        if (box.containsKey(key)) {
          await box.delete(key);
          deletedCount++;
        }
      }

      return deletedCount;
    } catch (e) {
      print('Error deleting multiple data: $e');
      return 0;
    }
  }

  /// Clear semua data dari box
  ///
  /// [boxName] - Nama box/tabel
  Future<bool> clear(String boxName) async {
    try {
      final box = await _getBox(boxName);
      await box.clear();
      return true;
    } catch (e) {
      print('Error clearing box: $e');
      return false;
    }
  }

  /// Check apakah key exists
  ///
  /// [boxName] - Nama box/tabel
  /// [key] - Key yang dicek
  Future<bool> containsKey(String boxName, dynamic key) async {
    try {
      final box = await _getBox(boxName);
      return box.containsKey(key);
    } catch (e) {
      print('Error checking key existence: $e');
      return false;
    }
  }

  /// Get jumlah data dalam box
  ///
  /// [boxName] - Nama box/tabel
  Future<int> count(String boxName) async {
    try {
      final box = await _getBox(boxName);
      return box.length;
    } catch (e) {
      print('Error getting count: $e');
      return 0;
    }
  }

  /// Get semua keys dari box
  ///
  /// [boxName] - Nama box/tabel
  Future<List<dynamic>> getKeys(String boxName) async {
    try {
      final box = await _getBox(boxName);
      return box.keys.toList();
    } catch (e) {
      print('Error getting keys: $e');
      return [];
    }
  }

  /// Close box tertentu
  ///
  /// [boxName] - Nama box yang akan ditutup
  Future<void> closeBox(String boxName) async {
    try {
      if (_boxes[boxName] != null && _boxes[boxName]!.isOpen) {
        await _boxes[boxName]!.close();
        _boxes.remove(boxName);
      }
    } catch (e) {
      print('Error closing box: $e');
    }
  }

  /// Close semua boxes
  Future<void> closeAllBoxes() async {
    try {
      for (var boxName in _boxes.keys.toList()) {
        await closeBox(boxName);
      }
    } catch (e) {
      print('Error closing all boxes: $e');
    }
  }

  /// Compact box untuk optimasi storage
  ///
  /// [boxName] - Nama box yang akan di-compact
  Future<void> compact(String boxName) async {
    try {
      final box = await _getBox(boxName);
      await box.compact();
    } catch (e) {
      print('Error compacting box: $e');
    }
  }
}
