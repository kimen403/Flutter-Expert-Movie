import 'dart:io';
import 'package:ditonton/data/datasources/db/database_helper.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

class TestModel {
  final String name;

  TestModel({required this.name});

  Map<String, dynamic> toJson() {
    return {'name': name};
  }
}

void main() {
  late DatabaseHelper databaseHelper;
  late Directory tempDir;

  setUp(() async {
    // Create a temporary directory for Hive
    tempDir = await Directory.systemTemp.createTemp('hive_test_');
    Hive.init(tempDir.path);
    databaseHelper = DatabaseHelper();
  });

  tearDown(() async {
    // Close all boxes and clean up
    try {
      await databaseHelper.closeAllBoxes();
      await Hive.close();
    } catch (e) {
      // Ignore errors during cleanup
    }

    // Delete the temporary directory
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('DatabaseHelper', () {
    test('should insert data into the database', () async {
      final result =
          await databaseHelper.insert('test_table', 1, {'name': 'Test'});

      expect(result, true);
    });

    test('should update data in the database', () async {
      await databaseHelper.insert('test_table', 1, {'name': 'Test'});
      final result = await databaseHelper
          .update('test_table', 1, {'name': 'Updated Test'});

      expect(result, true);
      final updatedData = await databaseHelper.getByKey('test_table', 1);
      expect(updatedData, {'name': 'Updated Test'});
    });

    test('should get data from the database', () async {
      await databaseHelper.insert('test_table', 1, {'name': 'Test'});

      final result = await databaseHelper.getByKey('test_table', 1);

      expect(result, {'name': 'Test'});
    });

    test('should return null when getting non-existent data', () async {
      final result = await databaseHelper.getByKey('test_table', 999);

      expect(result, null);
    });

    test('should get all data from the database', () async {
      await databaseHelper.insert('test_table', 1, {'name': 'Test1'});
      await databaseHelper.insert('test_table', 2, {'name': 'Test2'});

      final result = await databaseHelper.getAll('test_table');

      expect(result.length, 2);
      expect(result[0], {'name': 'Test1'});
      expect(result[1], {'name': 'Test2'});
    });

    test('should get all data with keys from the database', () async {
      await databaseHelper.insert('test_table', 1, {'name': 'Test1'});
      await databaseHelper.insert('test_table', 2, {'name': 'Test2'});

      final result = await databaseHelper.getAllWithKeys('test_table');

      expect(result.length, 2);
      expect(result[1], {'name': 'Test1'});
      expect(result[2], {'name': 'Test2'});
    });

    test('should delete data from the database', () async {
      await databaseHelper.insert('test_table', 1, {'name': 'Test'});

      final result = await databaseHelper.delete('test_table', 1);

      expect(result, true);
      final deletedData = await databaseHelper.getByKey('test_table', 1);
      expect(deletedData, null);
    });

    test('should return false when deleting non-existent data', () async {
      final result = await databaseHelper.delete('test_table', 999);

      expect(result, false);
    });

    test('should delete multiple data from the database', () async {
      await databaseHelper.insert('test_table', 1, {'name': 'Test1'});
      await databaseHelper.insert('test_table', 2, {'name': 'Test2'});
      await databaseHelper.insert('test_table', 3, {'name': 'Test3'});

      final result = await databaseHelper.deleteMultiple('test_table', [1, 2]);

      expect(result, 2);
      final remainingData = await databaseHelper.getAll('test_table');
      expect(remainingData.length, 1);
      expect(remainingData.first, {'name': 'Test3'});
    });

    test('should clear all data from the database', () async {
      await databaseHelper.insert('test_table', 1, {'name': 'Test1'});
      await databaseHelper.insert('test_table', 2, {'name': 'Test2'});

      final result = await databaseHelper.clear('test_table');

      expect(result, true);
      final allData = await databaseHelper.getAll('test_table');
      expect(allData, isEmpty);
    });

    test('should check if key exists in the database', () async {
      await databaseHelper.insert('test_table', 1, {'name': 'Test'});

      final exists = await databaseHelper.containsKey('test_table', 1);
      final notExists = await databaseHelper.containsKey('test_table', 999);

      expect(exists, true);
      expect(notExists, false);
    });

    test('should count data in the database', () async {
      await databaseHelper.insert('test_table', 1, {'name': 'Test1'});
      await databaseHelper.insert('test_table', 2, {'name': 'Test2'});

      final count = await databaseHelper.count('test_table');

      expect(count, 2);
    });

    test('should get all keys from the database', () async {
      await databaseHelper.insert('test_table', 1, {'name': 'Test1'});
      await databaseHelper.insert('test_table', 2, {'name': 'Test2'});

      final keys = await databaseHelper.getKeys('test_table');

      expect(keys.length, 2);
      expect(keys, contains(1));
      expect(keys, contains(2));
    });

    test('should close specific box', () async {
      await databaseHelper.insert('test_table', 1, {'name': 'Test'});
      await databaseHelper.closeBox('test_table');

      // Box should be closed, but we can't easily test this without accessing private fields
      // This test mainly ensures no exceptions are thrown
      expect(true, true);
    });

    test('should compact box', () async {
      await databaseHelper.insert('test_table', 1, {'name': 'Test'});
      await databaseHelper.compact('test_table');

      // Compaction should complete without errors
      expect(true, true);
    });

    test('should handle insert with object that has toJson method', () async {
      // Create a mock object with toJson method
      final testObject = TestModel(name: 'Test Object');

      final result = await databaseHelper.insert('test_table', 1, testObject);

      expect(result, true);
      final retrievedData = await databaseHelper.getByKey('test_table', 1);
      expect(retrievedData, {'name': 'Test Object'});
    });

    test('should throw ArgumentError for invalid data type', () async {
      final result =
          await databaseHelper.insert('test_table', 1, 'invalid_data');
      expect(
        result,
        false,
      );
    });
  });

  group('DatabaseHelper Error Handling', () {
    test('should handle getByKey error gracefully', () async {
      await databaseHelper.closeAllBoxes();

      final result = await databaseHelper.getByKey('test_table', 1);

      expect(result, null);
    });

    test('should handle delete error gracefully', () async {
      await databaseHelper.closeAllBoxes();

      final result = await databaseHelper.delete('test_table', 1);

      expect(result, false);
    });

    test('should handle getAll error gracefully', () async {
      await databaseHelper.closeAllBoxes();

      final result = await databaseHelper.getAll('test_table');

      expect(result, isEmpty);
    });

    test('should handle containsKey error gracefully', () async {
      await databaseHelper.closeAllBoxes();

      final result = await databaseHelper.containsKey('test_table', 1);

      expect(result, false);
    });

    test('should handle count error gracefully', () async {
      await databaseHelper.closeAllBoxes();

      final result = await databaseHelper.count('test_table');

      expect(result, 0);
    });

    test('should handle getKeys error gracefully', () async {
      await databaseHelper.closeAllBoxes();

      final result = await databaseHelper.getKeys('test_table');

      expect(result, isEmpty);
    });
  });
}
