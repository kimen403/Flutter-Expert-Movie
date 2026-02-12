import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tId = 1;
  const tTitle = 'Test Movie';
  const tPosterPath = '/test.jpg';
  const tOverview = 'Test overview';

  final tMovieTable = MovieTable(
    id: tId,
    title: tTitle,
    posterPath: tPosterPath,
    overview: tOverview,
  );

  final tMovie = Movie.watchlist(
    id: tId,
    title: tTitle,
    posterPath: tPosterPath,
    overview: tOverview,
  );

  final tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: '',
    genres: const [],
    id: tId,
    originalTitle: '',
    overview: tOverview,
    posterPath: tPosterPath,
    releaseDate: '',
    runtime: 0,
    title: tTitle,
    voteAverage: 0,
    voteCount: 0,
  );

  group('MovieTable', () {
    test('should create MovieTable from Map correctly', () {
      final map = {
        'id': tId,
        'title': tTitle,
        'posterPath': tPosterPath,
        'overview': tOverview,
      };

      final result = MovieTable.fromMap(map);

      expect(result, tMovieTable);
    });

    test('should create MovieTable from Entity correctly', () {
      final result = MovieTable.fromEntity(tMovieDetail);

      expect(result, tMovieTable);
    });

    test('should create MovieTable from JSON (map) correctly', () {
      final json = {
        'id': tId,
        'title': tTitle,
        'posterPath': tPosterPath,
        'overview': tOverview,
      };

      final result = MovieTable.fromMap(json);

      expect(result, tMovieTable);
    });

    test('should convert to JSON correctly', () {
      final expectedJson = {
        'id': tId,
        'title': tTitle,
        'posterPath': tPosterPath,
        'overview': tOverview,
      };

      final result = tMovieTable.toJson();

      expect(result, expectedJson);
    });

    test('should convert to Entity correctly', () {
      final result = tMovieTable.toEntity();

      expect(result, tMovie);
    });

    test('should have correct props', () {
      expect(tMovieTable.props, [tId, tTitle, tPosterPath, tOverview]);
    });

    test('should be equal when all properties are the same', () {
      final other = MovieTable(
        id: tId,
        title: tTitle,
        posterPath: tPosterPath,
        overview: tOverview,
      );

      expect(tMovieTable, other);
    });

    test('should not be equal when id is different', () {
      final other = MovieTable(
        id: 2,
        title: tTitle,
        posterPath: tPosterPath,
        overview: tOverview,
      );

      expect(tMovieTable, isNot(other));
    });

    test('should not be equal when title is different', () {
      final other = MovieTable(
        id: tId,
        title: 'Different Title',
        posterPath: tPosterPath,
        overview: tOverview,
      );

      expect(tMovieTable, isNot(other));
    });

    test('should not be equal when posterPath is different', () {
      final other = MovieTable(
        id: tId,
        title: tTitle,
        posterPath: '/different.jpg',
        overview: tOverview,
      );

      expect(tMovieTable, isNot(other));
    });

    test('should not be equal when overview is different', () {
      final other = MovieTable(
        id: tId,
        title: tTitle,
        posterPath: tPosterPath,
        overview: 'Different overview',
      );

      expect(tMovieTable, isNot(other));
    });
  });
}
