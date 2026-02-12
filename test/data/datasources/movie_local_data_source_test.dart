import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MovieLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = MovieLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  final boxName = 'watchlist_movies';
  group('save watchlist', () {
    test('should return success message when insert to database is success',
        () async {
      // arrange
      when(mockDatabaseHelper.insert(
              boxName, testMovieTable.id, testMovieTable))
          .thenAnswer((_) async => true);
      // act
      final result = await dataSource.insertWatchlist(testMovieTable);
      // assert
      expect(result, 'Added to Watchlist');
    });

    test('should throw DatabaseException when insert to database is failed',
        () async {
      // arrange
      when(mockDatabaseHelper.insert(
              boxName, testMovieTable.id, testMovieTable))
          .thenThrow(Exception());
      // act
      final call = dataSource.insertWatchlist(testMovieTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove from database is success',
        () async {
      // arrange
      when(mockDatabaseHelper.delete(boxName, testMovieTable.id))
          .thenAnswer((_) async => true);
      // act
      final result = await dataSource.removeWatchlist(testMovieTable);
      // assert
      expect(result, 'Removed from Watchlist');
    });

    test('should throw DatabaseException when remove from database is failed',
        () async {
      // arrange
      when(mockDatabaseHelper.delete(boxName, testMovieTable.id))
          .thenThrow(Exception());
      // act
      final call = dataSource.removeWatchlist(testMovieTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('Get Movie Detail By Id', () {
    final tId = 1;

    test('should return Movie Detail Table when data is found', () async {
      // arrange
      when(mockDatabaseHelper.getByKey(boxName, tId))
          .thenAnswer((_) async => testMovieMap);
      // act
      final result = await dataSource.getMovieById(tId);
      // assert
      expect(result, testMovieTable);
    });

    test('should return null when data is not found', () async {
      // arrange
      when(mockDatabaseHelper.getByKey(boxName, tId))
          .thenAnswer((_) async => null);
      // act
      final result = await dataSource.getMovieById(tId);
      // assert
      expect(result, null);
    });

    test('should throw DatabaseException when getting movie by id fails',
        () async {
      // arrange
      when(mockDatabaseHelper.getByKey(boxName, tId)).thenThrow(Exception());
      // act
      final call = dataSource.getMovieById(tId);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('get watchlist movies', () {
    test('should return list of MovieTable from database', () async {
      // arrange
      when(mockDatabaseHelper.getAll(boxName))
          .thenAnswer((_) async => [testMovieMap]);
      // act
      final result = await dataSource.getWatchlistMovies();
      // assert
      expect(result, [testMovieTable]);
    });

    test('should throw DatabaseException when getting watchlist movies fails',
        () async {
      // arrange
      when(mockDatabaseHelper.getAll(boxName)).thenThrow(Exception());
      // act
      final call = dataSource.getWatchlistMovies();
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('check if movie is in watchlist', () {
    final tId = 1;

    test('should return true when movie is in watchlist', () async {
      // arrange
      when(mockDatabaseHelper.containsKey(boxName, tId))
          .thenAnswer((_) async => true);
      // act
      final result = await dataSource.isInWatchlist(tId);
      // assert
      expect(result, true);
    });

    test('should return false when movie is not in watchlist', () async {
      // arrange
      when(mockDatabaseHelper.containsKey(boxName, tId))
          .thenAnswer((_) async => false);
      // act
      final result = await dataSource.isInWatchlist(tId);
      // assert
      expect(result, false);
    });

    test('should throw DatabaseException when checking watchlist status fails',
        () async {
      // arrange
      when(mockDatabaseHelper.containsKey(boxName, tId)).thenThrow(Exception());
      // act
      final call = dataSource.isInWatchlist(tId);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('get watchlist count', () {
    test('should return watchlist count from database', () async {
      // arrange
      when(mockDatabaseHelper.count(boxName)).thenAnswer((_) async => 5);
      // act
      final result = await dataSource.getWatchlistCount();
      // assert
      expect(result, 5);
    });

    test('should throw DatabaseException when getting watchlist count fails',
        () async {
      // arrange
      when(mockDatabaseHelper.count(boxName)).thenThrow(Exception());
      // act
      final call = dataSource.getWatchlistCount();
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('clear watchlist', () {
    test('should return success message when clear watchlist is success',
        () async {
      // arrange
      when(mockDatabaseHelper.clear(boxName)).thenAnswer((_) async => true);
      // act
      final result = await dataSource.clearWatchlist();
      // assert
      expect(result, 'Watchlist cleared successfully');
    });

    test('should throw DatabaseException when clear watchlist fails', () async {
      // arrange
      when(mockDatabaseHelper.clear(boxName)).thenThrow(Exception());
      // act
      final call = dataSource.clearWatchlist();
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });
}
