import 'package:ditonton/data/models/tv_series_table.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tId = 1;
  const tName = 'Test TV Series';
  const tPosterPath = '/test.jpg';
  const tOverview = 'Test overview';

  final tTvSeriesTable = TvSeriesTable(
    id: tId,
    name: tName,
    posterPath: tPosterPath,
    overview: tOverview,
  );

  final tTvSeries = TvSeries.watchlist(
    id: tId,
    name: tName,
    posterPath: tPosterPath,
    overview: tOverview,
  );

  group('TvSeriesTable', () {
    test('should create TvSeriesTable from Map correctly', () {
      final map = {
        'id': tId,
        'name': tName,
        'posterPath': tPosterPath,
        'overview': tOverview,
      };

      final result = TvSeriesTable.fromMap(map);

      expect(result, tTvSeriesTable);
    });

    test('should create TvSeriesTable from Entity correctly', () {
      final result = TvSeriesTable.fromEntity(tTvSeries);

      expect(result, tTvSeriesTable);
    });

    test('should create TvSeriesTable from JSON correctly', () {
      final json = {
        'id': tId,
        'name': tName,
        'posterPath': tPosterPath,
        'overview': tOverview,
      };

      final result = TvSeriesTable.fromJson(json);

      expect(result, tTvSeriesTable);
    });

    test('should convert to JSON correctly', () {
      final expectedJson = {
        'id': tId,
        'name': tName,
        'posterPath': tPosterPath,
        'overview': tOverview,
      };

      final result = tTvSeriesTable.toJson();

      expect(result, expectedJson);
    });

    test('should convert to Map correctly', () {
      final expectedMap = {
        'id': tId,
        'name': tName,
        'posterPath': tPosterPath,
        'overview': tOverview,
      };

      final result = tTvSeriesTable.toMap();

      expect(result, expectedMap);
    });

    test('should convert to Entity correctly', () {
      final result = tTvSeriesTable.toEntity();

      expect(result, tTvSeries);
    });

    test('should have correct props', () {
      expect(tTvSeriesTable.props, [tId, tName, tPosterPath, tOverview]);
    });

    test('should be equal when all properties are the same', () {
      final other = TvSeriesTable(
        id: tId,
        name: tName,
        posterPath: tPosterPath,
        overview: tOverview,
      );

      expect(tTvSeriesTable, other);
    });

    test('should not be equal when id is different', () {
      final other = TvSeriesTable(
        id: 2,
        name: tName,
        posterPath: tPosterPath,
        overview: tOverview,
      );

      expect(tTvSeriesTable, isNot(other));
    });

    test('should not be equal when name is different', () {
      final other = TvSeriesTable(
        id: tId,
        name: 'Different Name',
        posterPath: tPosterPath,
        overview: tOverview,
      );

      expect(tTvSeriesTable, isNot(other));
    });

    test('should not be equal when posterPath is different', () {
      final other = TvSeriesTable(
        id: tId,
        name: tName,
        posterPath: '/different.jpg',
        overview: tOverview,
      );

      expect(tTvSeriesTable, isNot(other));
    });

    test('should not be equal when overview is different', () {
      final other = TvSeriesTable(
        id: tId,
        name: tName,
        posterPath: tPosterPath,
        overview: 'Different overview',
      );

      expect(tTvSeriesTable, isNot(other));
    });
  });
}
