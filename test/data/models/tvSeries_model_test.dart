import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  final tTvSeriesModel = TvSeriesModel(
    adult: false,
    backdropPath: "/qg8Gv2w0dDL8cMsG2QO2hWp58wy.jpg",
    genreIds: [10765, 9648, 35],
    id: 119051,
    originCountry: ["US"],
    originalLanguage: "en",
    originalName: "Wednesday",
    overview:
        "Smart, sarcastic and a little dead inside, Wednesday Addams investigates twisted mysteries while making new friends — and foes — at Nevermore Academy.",
    popularity: 391.7456,
    posterPath: "/36xXlhEpQqVVPuiZhfoQuaY4OlA.jpg",
    firstAirDate: "2022-11-23",
    name: "Wednesday",
    voteAverage: 8.4,
    voteCount: 9486,
  );

  final tTvSeries = TvSeries(
    adult: false,
    backdropPath: "/qg8Gv2w0dDL8cMsG2QO2hWp58wy.jpg",
    genreIds: [10765, 9648, 35],
    id: 119051,
    originCountry: ["US"],
    originalLanguage: "en",
    originalName: "Wednesday",
    overview:
        "Smart, sarcastic and a little dead inside, Wednesday Addams investigates twisted mysteries while making new friends — and foes — at Nevermore Academy.",
    popularity: 391.7456,
    posterPath: "/36xXlhEpQqVVPuiZhfoQuaY4OlA.jpg",
    firstAirDate: "2022-11-23",
    name: "Wednesday",
    voteAverage: 8.4,
    voteCount: 9486,
  );

  test('should be a subclass of TvSeries entity', () async {
    // assert
    final result = tTvSeriesModel.toEntity();
    expect(result, tTvSeries);
  });

  group('toEntity', () {
    test('should convert TvSeriesModel to TvSeries entity', () {
      // act
      final result = tTvSeriesModel.toEntity();
      // assert
      expect(result, tTvSeries);
    });
  });

  group('JSON Serialization', () {
    test('fromJson should return a valid model from JSON', () {
      // arrange
      final Map<String, dynamic> jsonMap = {
        "adult": false,
        "backdrop_path": "/qg8Gv2w0dDL8cMsG2QO2hWp58wy.jpg",
        "genre_ids": [10765, 9648, 35],
        "id": 119051,
        "origin_country": ["US"],
        "original_language": "en",
        "original_name": "Wednesday",
        "overview":
            "Smart, sarcastic and a little dead inside, Wednesday Addams investigates twisted mysteries while making new friends — and foes — at Nevermore Academy.",
        "popularity": 391.7456,
        "poster_path": "/36xXlhEpQqVVPuiZhfoQuaY4OlA.jpg",
        "first_air_date": "2022-11-23",
        "name": "Wednesday",
        "vote_average": 8.4,
        "vote_count": 9486
      };

      // act
      final result = TvSeriesModel.fromJson(jsonMap);

      // assert
      expect(result, tTvSeriesModel);
    });

    test('toJson should return a JSON map containing proper data', () {
      // act
      final result = tTvSeriesModel.toJson();

      // assert
      final expectedJsonMap = {
        "adult": false,
        "backdrop_path": "/qg8Gv2w0dDL8cMsG2QO2hWp58wy.jpg",
        "genre_ids": [10765, 9648, 35],
        "id": 119051,
        "origin_country": ["US"],
        "original_language": "en",
        "original_name": "Wednesday",
        "overview":
            "Smart, sarcastic and a little dead inside, Wednesday Addams investigates twisted mysteries while making new friends — and foes — at Nevermore Academy.",
        "popularity": 391.7456,
        "poster_path": "/36xXlhEpQqVVPuiZhfoQuaY4OlA.jpg",
        "first_air_date": "2022-11-23",
        "name": "Wednesday",
        "vote_average": 8.4,
        "vote_count": 9486
      };
      expect(result, expectedJsonMap);
    });
  });

  group('Raw JSON Serialization', () {
    test('fromRawJson should return a valid model from raw JSON string', () {
      // arrange
      final rawJson =
          '{"adult":false,"backdrop_path":"/qg8Gv2w0dDL8cMsG2QO2hWp58wy.jpg","genre_ids":[10765,9648,35],"id":119051,"origin_country":["US"],"original_language":"en","original_name":"Wednesday","overview":"Smart, sarcastic and a little dead inside, Wednesday Addams investigates twisted mysteries while making new friends — and foes — at Nevermore Academy.","popularity":391.7456,"poster_path":"/36xXlhEpQqVVPuiZhfoQuaY4OlA.jpg","first_air_date":"2022-11-23","name":"Wednesday","vote_average":8.4,"vote_count":9486}';

      // act
      final result = TvSeriesModel.fromRawJson(rawJson);

      // assert
      expect(result, tTvSeriesModel);
    });

    test('toRawJson should return a raw JSON string containing proper data',
        () {
      // act
      final result = tTvSeriesModel.toRawJson();

      // assert
      final expectedRawJson =
          '{"adult":false,"backdrop_path":"/qg8Gv2w0dDL8cMsG2QO2hWp58wy.jpg","genre_ids":[10765,9648,35],"id":119051,"origin_country":["US"],"original_language":"en","original_name":"Wednesday","overview":"Smart, sarcastic and a little dead inside, Wednesday Addams investigates twisted mysteries while making new friends — and foes — at Nevermore Academy.","popularity":391.7456,"poster_path":"/36xXlhEpQqVVPuiZhfoQuaY4OlA.jpg","first_air_date":"2022-11-23","name":"Wednesday","vote_average":8.4,"vote_count":9486}';
      expect(result, expectedRawJson);
    });
  });
}
