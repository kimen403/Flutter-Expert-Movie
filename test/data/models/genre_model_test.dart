import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tId = 1;
  const tName = 'Action';

  final tGenreModel = GenreModel(id: tId, name: tName);
  final tGenre = Genre(id: tId, name: tName);

  group('GenreModel', () {
    test('should create GenreModel from JSON correctly', () {
      final json = {
        'id': tId,
        'name': tName,
      };

      final result = GenreModel.fromJson(json);

      expect(result, tGenreModel);
    });

    test('should convert to JSON correctly', () {
      final expectedJson = {
        'id': tId,
        'name': tName,
      };

      final result = tGenreModel.toJson();

      expect(result, expectedJson);
    });

    test('should convert to Entity correctly', () {
      final result = tGenreModel.toEntity();

      expect(result, tGenre);
    });

    test('should have correct props', () {
      expect(tGenreModel.props, [tId, tName]);
    });

    test('should be equal when all properties are the same', () {
      final other = GenreModel(id: tId, name: tName);

      expect(tGenreModel, other);
    });

    test('should not be equal when id is different', () {
      final other = GenreModel(id: 2, name: tName);

      expect(tGenreModel, isNot(other));
    });

    test('should not be equal when name is different', () {
      final other = GenreModel(id: tId, name: 'Drama');

      expect(tGenreModel, isNot(other));
    });
  });
}
