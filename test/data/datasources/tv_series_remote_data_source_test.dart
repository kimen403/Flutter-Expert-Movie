import 'dart:convert';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_series_remote_data_source.dart';
import 'package:ditonton/data/models/tv_series_response.dart';
import 'package:ditonton/data/models/tv_series_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late TvSeriesRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvSeriesRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get Popular TvSeries', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/simple_tv_series.json')))
        .tvSeriesList;

    test('should return list of TvSeries Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/simple_tv_series.json'), 200,
              headers: {'content-type': 'application/json; charset=utf-8'}));
      // act
      final result = await dataSource.getTvSeriesPopuler();
      // assert
      expect(result, tTvSeriesList);
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTvSeriesPopuler();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Now Playing TvSeries', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/tv_series_populer.json')))
        .tvSeriesList;

    test('should return list of TvSeries Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv_series_populer.json'), 200,
              headers: {'content-type': 'application/json; charset=utf-8'}));
      // act
      final result = await dataSource.getNowPlayingTvSeries();
      // assert
      expect(result, tTvSeriesList);
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getNowPlayingTvSeries();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Top Rated TvSeries', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/simple_tv_series.json')))
        .tvSeriesList;

    test('should return list of TvSeries Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/simple_tv_series.json'), 200,
              headers: {'content-type': 'application/json; charset=utf-8'}));
      // act
      final result = await dataSource.getTopRatedTvSeries();
      // assert
      expect(result, tTvSeriesList);
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTopRatedTvSeries();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get TvSeries Recommendations', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/simple_tv_series.json')))
        .tvSeriesList;

    test('should return list of TvSeries Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/simple_tv_series.json'), 200,
              headers: {'content-type': 'application/json; charset=utf-8'}));
      // act
      final result = await dataSource.getTvSeriesRecommendations();
      // assert
      expect(result, tTvSeriesList);
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTvSeriesRecommendations();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get TvSeries Detail', () {
    final tId = 1;
    final tTvSeriesDetail = TvSeriesDetailModel.fromJson(
        json.decode(readJson('dummy_data/simple_tv_series_detail.json')));

    test('should return TvSeries detail when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/simple_tv_series_detail.json'), 200,
              headers: {'content-type': 'application/json; charset=utf-8'}));
      // act
      final result = await dataSource.getTvSeriesDetail(tId);
      // assert
      expect(result, equals(tTvSeriesDetail));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTvSeriesDetail(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search TvSeries', () {
    final tQuery = 'test';
    final tTvSeriesList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/simple_tv_series.json')))
        .tvSeriesList;

    test('should return list of TvSeries Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/simple_tv_series.json'), 200,
              headers: {'content-type': 'application/json; charset=utf-8'}));
      // act
      final result = await dataSource.searchTvSeries(tQuery);
      // assert
      expect(result, tTvSeriesList);
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.searchTvSeries(tQuery);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get TvSeries Recommendations By Id', () {
    final tId = 1;
    final tTvSeriesList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/simple_tv_series.json')))
        .tvSeriesList;

    test('should return list of TvSeries Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/simple_tv_series.json'), 200,
              headers: {'content-type': 'application/json; charset=utf-8'}));
      // act
      final result = await dataSource.getTvSeriesRecommendationsById(tId);
      // assert
      expect(result, tTvSeriesList);
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTvSeriesRecommendationsById(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
