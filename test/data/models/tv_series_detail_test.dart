import 'dart:convert';

import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/tv_series_detail_model.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTvSeriesDetailModel = TvSeriesDetailModel(
      adult: false,
      backdropPath: "/qg8Gv2w0dDL8cMsG2QO2hWp58wy.jpg",
      episodeRunTime: [30],
      firstAirDate: "2022-11-23",
      genres: [
        GenreModel(id: 10765, name: "Sci-Fi & Fantasy"),
        GenreModel(id: 9648, name: "Mystery"),
        GenreModel(id: 35, name: "Comedy")
      ],
      homepage: "https://www.netflix.com/title/81213999",
      id: 119051,
      inProduction: false,
      languages: ["en"],
      lastAirDate: "2022-11-23",
      name: "Wednesday",
      nextEpisodeToAir: null,
      numberOfEpisodes: 8,
      numberOfSeasons: 1,
      originCountry: ["US"],
      originalLanguage: "en",
      originalName: "Wednesday",
      overview:
          "Smart, sarcastic and a little dead inside, Wednesday Addams investigates twisted mysteries while making new friends — and foes — at Nevermore Academy.",
      popularity: 391.7456,
      posterPath: "/36xXlhEpQqVVPuiZhfoQuaY4OlA.jpg",
      status: "Ended",
      tagline: "Wednesday's got a brand new mystery to solve.",
      type: "Scripted",
      voteAverage: 8.4,
      voteCount: 9486);

  final tTvSeriesDetail = TvSeriesDetail(
      adult: false,
      backdropPath: "/qg8Gv2w0dDL8cMsG2QO2hWp58wy.jpg",
      episodeRunTime: [30],
      firstAirDate: "2022-11-23",
      genres: [
        Genre(id: 10765, name: "Sci-Fi & Fantasy"),
        Genre(id: 9648, name: "Mystery"),
        Genre(id: 35, name: "Comedy")
      ],
      homepage: "https://www.netflix.com/title/81213999",
      id: 119051,
      inProduction: false,
      languages: ["en"],
      lastAirDate: "2022-11-23",
      name: "Wednesday",
      nextEpisodeToAir: null,
      numberOfEpisodes: 8,
      numberOfSeasons: 1,
      originCountry: ["US"],
      originalLanguage: "en",
      originalName: "Wednesday",
      overview:
          "Smart, sarcastic and a little dead inside, Wednesday Addams investigates twisted mysteries while making new friends — and foes — at Nevermore Academy.",
      popularity: 391.7456,
      posterPath: "/36xXlhEpQqVVPuiZhfoQuaY4OlA.jpg",
      status: "Ended",
      tagline: "Wednesday's got a brand new mystery to solve.",
      type: "Scripted",
      voteAverage: 8.4,
      voteCount: 9486);

  group('TvSeriesDetailModel', () {
    test('should create TvSeriesDetailModel from JSON correctly', () {
      final json = {
        "adult": false,
        "backdrop_path": "/qg8Gv2w0dDL8cMsG2QO2hWp58wy.jpg",
        "episode_run_time": [30],
        "first_air_date": "2022-11-23",
        "genres": [
          {"id": 10765, "name": "Sci-Fi & Fantasy"},
          {"id": 9648, "name": "Mystery"},
          {"id": 35, "name": "Comedy"}
        ],
        "homepage": "https://www.netflix.com/title/81213999",
        "id": 119051,
        "in_production": false,
        "languages": ["en"],
        "last_air_date": "2022-11-23",
        "name": "Wednesday",
        "next_episode_to_air": null,
        "number_of_episodes": 8,
        "number_of_seasons": 1,
        "origin_country": ["US"],
        "original_language": "en",
        "original_name": "Wednesday",
        "overview":
            "Smart, sarcastic and a little dead inside, Wednesday Addams investigates twisted mysteries while making new friends — and foes — at Nevermore Academy.",
        "popularity": 391.7456,
        "poster_path": "/36xXlhEpQqVVPuiZhfoQuaY4OlA.jpg",
        "status": "Ended",
        "tagline": "Wednesday's got a brand new mystery to solve.",
        "type": "Scripted",
        "vote_average": 8.4,
        "vote_count": 9486
      };

      final result = TvSeriesDetailModel.fromJson(json);

      expect(result, tTvSeriesDetailModel);
    });

    test('should convert to JSON correctly', () {
      final expectedJson = {
        "adult": false,
        "backdrop_path": "/qg8Gv2w0dDL8cMsG2QO2hWp58wy.jpg",
        "episode_run_time": [30],
        "first_air_date": "2022-11-23",
        "genres": [
          {"id": 10765, "name": "Sci-Fi & Fantasy"},
          {"id": 9648, "name": "Mystery"},
          {"id": 35, "name": "Comedy"}
        ],
        "homepage": "https://www.netflix.com/title/81213999",
        "id": 119051,
        "in_production": false,
        "languages": ["en"],
        "last_air_date": "2022-11-23",
        "name": "Wednesday",
        "next_episode_to_air": null,
        "number_of_episodes": 8,
        "number_of_seasons": 1,
        "origin_country": ["US"],
        "original_language": "en",
        "original_name": "Wednesday",
        "overview":
            "Smart, sarcastic and a little dead inside, Wednesday Addams investigates twisted mysteries while making new friends — and foes — at Nevermore Academy.",
        "popularity": 391.7456,
        "poster_path": "/36xXlhEpQqVVPuiZhfoQuaY4OlA.jpg",
        "status": "Ended",
        "tagline": "Wednesday's got a brand new mystery to solve.",
        "type": "Scripted",
        "vote_average": 8.4,
        "vote_count": 9486
      };

      final result = tTvSeriesDetailModel.toJson();

      expect(result, expectedJson);
    });

    test('should create TvSeriesDetailModel from Raw JSON correctly', () {
      final rawJson = json.encode({
        "adult": false,
        "backdrop_path": "/qg8Gv2w0dDL8cMsG2QO2hWp58wy.jpg",
        "episode_run_time": [30],
        "first_air_date": "2022-11-23",
        "genres": [
          {"id": 10765, "name": "Sci-Fi & Fantasy"},
          {"id": 9648, "name": "Mystery"},
          {"id": 35, "name": "Comedy"}
        ],
        "homepage": "https://www.netflix.com/title/81213999",
        "id": 119051,
        "in_production": false,
        "languages": ["en"],
        "last_air_date": "2022-11-23",
        "name": "Wednesday",
        "next_episode_to_air": null,
        "number_of_episodes": 8,
        "number_of_seasons": 1,
        "origin_country": ["US"],
        "original_language": "en",
        "original_name": "Wednesday",
        "overview":
            "Smart, sarcastic and a little dead inside, Wednesday Addams investigates twisted mysteries while making new friends — and foes — at Nevermore Academy.",
        "popularity": 391.7456,
        "poster_path": "/36xXlhEpQqVVPuiZhfoQuaY4OlA.jpg",
        "status": "Ended",
        "tagline": "Wednesday's got a brand new mystery to solve.",
        "type": "Scripted",
        "vote_average": 8.4,
        "vote_count": 9486
      });

      final result = TvSeriesDetailModel.fromRawJson(rawJson);

      expect(result, tTvSeriesDetailModel);
    });

    test('should convert to Raw JSON correctly', () {
      final expectedRawJson = json.encode({
        "adult": false,
        "backdrop_path": "/qg8Gv2w0dDL8cMsG2QO2hWp58wy.jpg",
        "episode_run_time": [30],
        "first_air_date": "2022-11-23",
        "genres": [
          {"id": 10765, "name": "Sci-Fi & Fantasy"},
          {"id": 9648, "name": "Mystery"},
          {"id": 35, "name": "Comedy"}
        ],
        "homepage": "https://www.netflix.com/title/81213999",
        "id": 119051,
        "in_production": false,
        "languages": ["en"],
        "last_air_date": "2022-11-23",
        "name": "Wednesday",
        "next_episode_to_air": null,
        "number_of_episodes": 8,
        "number_of_seasons": 1,
        "origin_country": ["US"],
        "original_language": "en",
        "original_name": "Wednesday",
        "overview":
            "Smart, sarcastic and a little dead inside, Wednesday Addams investigates twisted mysteries while making new friends — and foes — at Nevermore Academy.",
        "popularity": 391.7456,
        "poster_path": "/36xXlhEpQqVVPuiZhfoQuaY4OlA.jpg",
        "status": "Ended",
        "tagline": "Wednesday's got a brand new mystery to solve.",
        "type": "Scripted",
        "vote_average": 8.4,
        "vote_count": 9486
      });

      final result = tTvSeriesDetailModel.toRawJson();

      expect(result, expectedRawJson);
    });

    test('should convert to Entity correctly', () {
      final result = tTvSeriesDetailModel.toEntity();

      expect(result, tTvSeriesDetail);
    });

    test('should have correct props', () {
      expect(tTvSeriesDetailModel.props, [
        false, // adult
        "/qg8Gv2w0dDL8cMsG2QO2hWp58wy.jpg", // backdropPath
        [30], // episodeRunTime
        "2022-11-23", // firstAirDate
        tTvSeriesDetailModel.genres, // genres
        "https://www.netflix.com/title/81213999", // homepage
        119051, // id
        false, // inProduction
        ["en"], // languages
        "2022-11-23", // lastAirDate
        "Wednesday", // name
        null, // nextEpisodeToAir
        8, // numberOfEpisodes
        1, // numberOfSeasons
        ["US"], // originCountry
        "en", // originalLanguage
        "Wednesday", // originalName
        "Smart, sarcastic and a little dead inside, Wednesday Addams investigates twisted mysteries while making new friends — and foes — at Nevermore Academy.", // overview
        391.7456, // popularity
        "/36xXlhEpQqVVPuiZhfoQuaY4OlA.jpg", // posterPath
        "Ended", // status
        "Wednesday's got a brand new mystery to solve.", // tagline
        "Scripted", // type
        8.4, // voteAverage
        9486, // voteCount
      ]);
    });

    test('should be equal when all properties are the same', () {
      final other = TvSeriesDetailModel(
          adult: false,
          backdropPath: "/qg8Gv2w0dDL8cMsG2QO2hWp58wy.jpg",
          episodeRunTime: [30],
          firstAirDate: "2022-11-23",
          genres: [
            GenreModel(id: 10765, name: "Sci-Fi & Fantasy"),
            GenreModel(id: 9648, name: "Mystery"),
            GenreModel(id: 35, name: "Comedy")
          ],
          homepage: "https://www.netflix.com/title/81213999",
          id: 119051,
          inProduction: false,
          languages: ["en"],
          lastAirDate: "2022-11-23",
          name: "Wednesday",
          nextEpisodeToAir: null,
          numberOfEpisodes: 8,
          numberOfSeasons: 1,
          originCountry: ["US"],
          originalLanguage: "en",
          originalName: "Wednesday",
          overview:
              "Smart, sarcastic and a little dead inside, Wednesday Addams investigates twisted mysteries while making new friends — and foes — at Nevermore Academy.",
          popularity: 391.7456,
          posterPath: "/36xXlhEpQqVVPuiZhfoQuaY4OlA.jpg",
          status: "Ended",
          tagline: "Wednesday's got a brand new mystery to solve.",
          type: "Scripted",
          voteAverage: 8.4,
          voteCount: 9486);

      expect(tTvSeriesDetailModel, other);
    });

    test('should not be equal when id is different', () {
      final other = TvSeriesDetailModel(
          adult: false,
          backdropPath: "/qg8Gv2w0dDL8cMsG2QO2hWp58wy.jpg",
          episodeRunTime: [30],
          firstAirDate: "2022-11-23",
          genres: [
            GenreModel(id: 10765, name: "Sci-Fi & Fantasy"),
            GenreModel(id: 9648, name: "Mystery"),
            GenreModel(id: 35, name: "Comedy")
          ],
          homepage: "https://www.netflix.com/title/81213999",
          id: 999999, // Different id
          inProduction: false,
          languages: ["en"],
          lastAirDate: "2022-11-23",
          name: "Wednesday",
          nextEpisodeToAir: null,
          numberOfEpisodes: 8,
          numberOfSeasons: 1,
          originCountry: ["US"],
          originalLanguage: "en",
          originalName: "Wednesday",
          overview:
              "Smart, sarcastic and a little dead inside, Wednesday Addams investigates twisted mysteries while making new friends — and foes — at Nevermore Academy.",
          popularity: 391.7456,
          posterPath: "/36xXlhEpQqVVPuiZhfoQuaY4OlA.jpg",
          status: "Ended",
          tagline: "Wednesday's got a brand new mystery to solve.",
          type: "Scripted",
          voteAverage: 8.4,
          voteCount: 9486);

      expect(tTvSeriesDetailModel, isNot(other));
    });
  });
}
