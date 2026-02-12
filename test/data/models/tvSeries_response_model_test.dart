import 'dart:convert';

import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/data/models/tv_series_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

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

  final tTvSeriesResponse = TvSeriesResponse(
    tvSeriesList: <TvSeriesModel>[tTvSeriesModel],
    page: 1,
    totalPages: 10173,
    totalResults: 203453,
  );

  group('fromJson', () {
    test('should return a valid model when the JSON is valid', () {
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/tv_series.json'));
      // act
      print(jsonMap);
      final result = TvSeriesResponse.fromJson(jsonMap);
      // assert
      expect(result, tTvSeriesResponse);
    });
  });

  group('toJson', () {
    test('should return a valid model to JSON', () async {
      // arrange
      final result = tTvSeriesResponse.toJson();

      final expectedJson = <String, dynamic>{
        "page": 1,
        "results": [
          {
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
            "vote_count": 9486,
          }
        ],
        "total_pages": 10173,
        "total_results": 203453,
      };
      // assert
      expect(result, expectedJson);
    });
  });
}
