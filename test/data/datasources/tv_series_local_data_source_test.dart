import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_series_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource =
        TvSeriesLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });
  final boxName = 'watchlist_tv_series';
  group('save watchlist', () {
    test('should return success message when insert is successful', () async {
      when(mockDatabaseHelper.insert(boxName, any, any))
          .thenAnswer((_) async => true);

      final result = await dataSource.insertWatchlist(testTvSeriesTable);

      expect(result, 'Added to Watchlist');
    });

    test('should throw DatabaseException when insert fails', () async {
      when(mockDatabaseHelper.insert(boxName, any, any))
          .thenThrow(Exception('Failed to insert'));

      final call = dataSource.insertWatchlist(testTvSeriesTable);

      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('get Series Watchlist', () {
    test('should return list of TvSeriesTable from database', () async {
      when(mockDatabaseHelper.getAll(boxName))
          .thenAnswer((_) async => [testTvSeriesMap]);

      final result = await dataSource.getTvSeriesWatchList();

      expect(result, [testTvSeriesTable]);
    });

    test('should return empty list when no data is found', () async {
      when(mockDatabaseHelper.getAll(boxName)).thenAnswer((_) async => []);

      final result = await dataSource.getTvSeriesWatchList();

      expect(result, []);
    });

    test('should throw DatabaseException when getAll fails', () async {
      when(mockDatabaseHelper.getAll(boxName))
          .thenThrow(Exception('Failed to get data'));

      final call = dataSource.getTvSeriesWatchList();

      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('delete Tv Series Watchlist', () {
    final tId = 1;
    test('should return success message when delete is successful', () async {
      when(mockDatabaseHelper.delete(boxName, any))
          .thenAnswer((_) async => true);

      final result = await dataSource.deleteTvSeriesWatchList(tId);

      expect(result, 'Removed from Watchlist');
    });

    test('should throw DatabaseException when delete fails', () async {
      when(mockDatabaseHelper.delete(boxName, any))
          .thenThrow(Exception('Failed to delete'));

      final call = dataSource.deleteTvSeriesWatchList(tId);

      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('is in Watchlist', () {
    final tId = 1;

    test('should return true when the tv series is in watchlist', () async {
      when(mockDatabaseHelper.containsKey(boxName, tId))
          .thenAnswer((_) async => true);

      final result = await dataSource.isInWatchlist(tId);

      expect(result, true);
    });

    test('should return false when the tv series is not in watchlist',
        () async {
      when(mockDatabaseHelper.containsKey(boxName, tId))
          .thenAnswer((_) async => false);

      final result = await dataSource.isInWatchlist(tId);

      expect(result, false);
    });
  });

  group('get Watchlist Count', () {
    test('should return watchlist count', () async {
      when(mockDatabaseHelper.count(boxName)).thenAnswer((_) async => 1);

      final result = await dataSource.getWatchlistCount();

      expect(result, 1);
    });

    test('should return 0 when watchlist is empty', () async {
      when(mockDatabaseHelper.count(boxName)).thenAnswer((_) async => 0);

      final result = await dataSource.getWatchlistCount();

      expect(result, 0);
    });

    test('should throw DatabaseException when count fails', () async {
      when(mockDatabaseHelper.count(boxName))
          .thenThrow(Exception('Failed to count'));

      final call = dataSource.getWatchlistCount();

      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('clear Watchlist Tv Series', () {
    test('should return success message when clear is successful', () async {
      when(mockDatabaseHelper.clear(boxName)).thenAnswer((_) async => true);

      final result = await dataSource.clearWatchlist();

      expect(result, 'Watchlist cleared');
    });

    test('should throw DatabaseException when clear fails', () async {
      when(mockDatabaseHelper.clear(boxName))
          .thenThrow(Exception('Failed to clear'));

      final call = dataSource.clearWatchlist();

      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });
}
