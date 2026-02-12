import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/tv_series_detail_model.dart';
import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/data/models/tv_series_table.dart';
import 'package:ditonton/data/repositories/tv_series_repository_impl.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesRepositoryImpl repository;
  late MockTvSeriesRemoteDataSource mockRemoteDataSource;
  late MockTvSeriesLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTvSeriesRemoteDataSource();
    mockLocalDataSource = MockTvSeriesLocalDataSource();
    repository = TvSeriesRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tTvSeriesModel = TvSeriesModel(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'Original Name',
    overview: 'Overview',
    popularity: 10.0,
    posterPath: 'posterPath',
    firstAirDate: '2022-01-01',
    name: 'Name',
    voteAverage: 8.0,
    voteCount: 100,
  );

  final tTvSeries = TvSeries(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'Original Name',
    overview: 'Overview',
    popularity: 10.0,
    posterPath: 'posterPath',
    firstAirDate: '2022-01-01',
    name: 'Name',
    voteAverage: 8.0,
    voteCount: 100,
  );

  final tTvSeriesModelList = <TvSeriesModel>[tTvSeriesModel];
  final tTvSeriesList = <TvSeries>[tTvSeries];

  final tGenreModel = GenreModel(id: 1, name: 'Action');
  final tGenre = Genre(id: 1, name: 'Action');

  final tTvSeriesDetailModel = TvSeriesDetailModel(
    adult: false,
    backdropPath: 'backdropPath',
    episodeRunTime: [60],
    firstAirDate: '2022-01-01',
    genres: [tGenreModel],
    homepage: 'https://example.com',
    id: 1,
    inProduction: true,
    languages: ['en'],
    lastAirDate: '2022-12-31',
    name: 'Name',
    nextEpisodeToAir: null,
    numberOfEpisodes: 10,
    numberOfSeasons: 1,
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'Original Name',
    overview: 'Overview',
    popularity: 10.0,
    posterPath: 'posterPath',
    status: 'Ended',
    tagline: 'Tagline',
    type: 'Scripted',
    voteAverage: 8.0,
    voteCount: 100,
  );

  final tTvSeriesDetail = TvSeriesDetail(
    adult: false,
    backdropPath: 'backdropPath',
    episodeRunTime: [60],
    firstAirDate: '2022-01-01',
    genres: [tGenre],
    homepage: 'https://example.com',
    id: 1,
    inProduction: true,
    languages: ['en'],
    lastAirDate: '2022-12-31',
    name: 'Name',
    nextEpisodeToAir: null,
    numberOfEpisodes: 10,
    numberOfSeasons: 1,
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'Original Name',
    overview: 'Overview',
    popularity: 10.0,
    posterPath: 'posterPath',
    status: 'Ended',
    tagline: 'Tagline',
    type: 'Scripted',
    voteAverage: 8.0,
    voteCount: 100,
  );

  final tTvSeriesTable = TvSeriesTable(
    id: 1,
    name: 'Name',
    posterPath: 'posterPath',
    overview: 'Overview',
  );

  final tTvSeriesTableList = <TvSeriesTable>[tTvSeriesTable];
  final tTvSeriesWatchlistList = <TvSeries>[
    TvSeries.watchlist(
      id: 1,
      name: 'Name',
      posterPath: 'posterPath',
      overview: 'Overview',
    )
  ];

  group('get Popular Tv Series', () {
    test(
        'should return TvSeries list when the call to data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvSeriesPopuler())
          .thenAnswer((_) async => tTvSeriesModelList);
      // act
      final result = await repository.getPopularTvSeries();
      verify(mockRemoteDataSource.getTvSeriesPopuler());
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesList);
    });

    test(
        'should return ServerFailure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvSeriesPopuler())
          .thenThrow(ServerException());
      // act
      final result = await repository.getPopularTvSeries();
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when the call to remote data source is connection error',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvSeriesPopuler())
          .thenThrow(SocketException('Failed to connect'));
      // act
      final result = await repository.getPopularTvSeries();
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('get Now Playing Tv Series', () {
    test(
        'should return TvSeries list when the call to data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getNowPlayingTvSeries())
          .thenAnswer((_) async => tTvSeriesModelList);
      // act
      final result = await repository.getNowPlayingTvSeries();
      verify(mockRemoteDataSource.getNowPlayingTvSeries());
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesList);
    });

    test(
        'should return ServerFailure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getNowPlayingTvSeries())
          .thenThrow(ServerException());
      // act
      final result = await repository.getNowPlayingTvSeries();
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when the call to remote data source is connection error',
        () async {
      // arrange
      when(mockRemoteDataSource.getNowPlayingTvSeries())
          .thenThrow(SocketException('Failed to connect'));
      // act
      final result = await repository.getNowPlayingTvSeries();
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('get Top Rated Tv Series', () {
    test(
        'should return TvSeries list when the call to data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTvSeries())
          .thenAnswer((_) async => tTvSeriesModelList);
      // act
      final result = await repository.getTopRatedTvSeries();
      verify(mockRemoteDataSource.getTopRatedTvSeries());
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesList);
    });

    test(
        'should return ServerFailure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTvSeries())
          .thenThrow(ServerException());
      // act
      final result = await repository.getTopRatedTvSeries();
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when the call to remote data source is connection error',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTvSeries())
          .thenThrow(SocketException('Failed to connect'));
      // act
      final result = await repository.getTopRatedTvSeries();
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('get Tv Series Recommendations', () {
    test(
        'should return TvSeries list when the call to data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvSeriesRecommendationsById(1))
          .thenAnswer((_) async => tTvSeriesModelList);
      // act
      final result = await repository.getTvSeriesRecommendations(1);
      verify(mockRemoteDataSource.getTvSeriesRecommendationsById(1));
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesList);
    });

    test(
        'should return ServerFailure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvSeriesRecommendationsById(1))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTvSeriesRecommendations(1);
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when the call to remote data source is connection error',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvSeriesRecommendationsById(1))
          .thenThrow(SocketException('Failed to connect'));
      // act
      final result = await repository.getTvSeriesRecommendations(1);
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('get Tv Series Watchlist', () {
    test(
        'should return TvSeries list when the call to data source is successful',
        () async {
      // arrange
      when(mockLocalDataSource.getTvSeriesWatchList())
          .thenAnswer((_) async => tTvSeriesTableList);
      // act
      final result = await repository.getWatchlistTvSeries();
      verify(mockLocalDataSource.getTvSeriesWatchList());
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesWatchlistList);
    });

    test(
        'should return DatabaseFailure when the call to local data source is unsuccessful',
        () async {
      // arrange
      when(mockLocalDataSource.getTvSeriesWatchList())
          .thenThrow(DatabaseException('Database error'));
      // act
      final result = await repository.getWatchlistTvSeries();
      // assert
      expect(result, Left(DatabaseFailure('Database error')));
    });
  });

  group('get Tv Series Detail', () {
    test(
        'should return TvSeriesDetail when the call to data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvSeriesDetail(1))
          .thenAnswer((_) async => tTvSeriesDetailModel);
      // act
      final result = await repository.getTvSeriesDetail(1);
      verify(mockRemoteDataSource.getTvSeriesDetail(1));
      // assert
      expect(result, Right(tTvSeriesDetail));
    });

    test(
        'should return ServerFailure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvSeriesDetail(1))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTvSeriesDetail(1);
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when the call to remote data source is connection error',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvSeriesDetail(1))
          .thenThrow(SocketException('Failed to connect'));
      // act
      final result = await repository.getTvSeriesDetail(1);
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('search Tv Series', () {
    test(
        'should return TvSeries list when the call to data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTvSeries('query'))
          .thenAnswer((_) async => tTvSeriesModelList);
      // act
      final result = await repository.searchTvSeries('query');
      verify(mockRemoteDataSource.searchTvSeries('query'));
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesList);
    });

    test(
        'should return ServerFailure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTvSeries('query'))
          .thenThrow(ServerException());
      // act
      final result = await repository.searchTvSeries('query');
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when the call to remote data source is connection error',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTvSeries('query'))
          .thenThrow(SocketException('Failed to connect'));
      // act
      final result = await repository.searchTvSeries('query');
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('save Watchlist Tv Series', () {
    test(
        'should return success message when the call to data source is successful',
        () async {
      // arrange
      when(mockLocalDataSource.insertWatchlist(tTvSeriesTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveWatchlist(tTvSeriesDetail);
      verify(mockLocalDataSource.insertWatchlist(tTvSeriesTable));
      // assert
      expect(result, Right('Added to Watchlist'));
    });

    test(
        'should return DatabaseFailure when the call to local data source is unsuccessful',
        () async {
      // arrange
      when(mockLocalDataSource.insertWatchlist(tTvSeriesTable))
          .thenThrow(DatabaseException('Database error'));
      // act
      final result = await repository.saveWatchlist(tTvSeriesDetail);
      // assert
      expect(result, Left(DatabaseFailure('Database error')));
    });
  });

  group('remove Watchlist Tv Series', () {
    test(
        'should return success message when the call to data source is successful',
        () async {
      // arrange
      when(mockLocalDataSource.deleteTvSeriesWatchList(1))
          .thenAnswer((_) async => 'Removed from Watchlist');
      // act
      final result = await repository.removeWatchlist(tTvSeriesDetail);
      verify(mockLocalDataSource.deleteTvSeriesWatchList(1));
      // assert
      expect(result, Right('Removed from Watchlist'));
    });

    test(
        'should return DatabaseFailure when the call to local data source is unsuccessful',
        () async {
      // arrange
      when(mockLocalDataSource.deleteTvSeriesWatchList(1))
          .thenThrow(DatabaseException('Database error'));
      // act
      final result = await repository.removeWatchlist(tTvSeriesDetail);
      // assert
      expect(result, Left(DatabaseFailure('Database error')));
    });
  });

  group('is Added To Watchlist Tv Series', () {
    test('should return true when the tv series is in watchlist', () async {
      // arrange
      when(mockLocalDataSource.isInWatchlist(1)).thenAnswer((_) async => true);
      // act
      final result = await repository.isAddedToWatchlist(1);
      verify(mockLocalDataSource.isInWatchlist(1));
      // assert
      expect(result, true);
    });

    test('should return false when the tv series is not in watchlist',
        () async {
      // arrange
      when(mockLocalDataSource.isInWatchlist(1)).thenAnswer((_) async => false);
      // act
      final result = await repository.isAddedToWatchlist(1);
      // assert
      expect(result, false);
    });
  });
}
