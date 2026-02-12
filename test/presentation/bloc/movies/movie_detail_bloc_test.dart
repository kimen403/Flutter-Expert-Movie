import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/movies/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/movies/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/movies/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/movies/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/movies/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/movies/movie_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
  });

  MovieDetailCubit buildCubit() => MovieDetailCubit(
        getMovieDetail: mockGetMovieDetail,
        getMovieRecommendations: mockGetMovieRecommendations,
        getWatchListStatus: mockGetWatchListStatus,
        saveWatchlist: mockSaveWatchlist,
        removeWatchlist: mockRemoveWatchlist,
      );

  final tId = 1;
  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovies = <Movie>[tMovie];

  group('fetchMovieDetail', () {
    void arrangeUseCase() {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Right(testMovieDetail));
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tMovies));
    }

    blocTest<MovieDetailCubit, MovieDetailState>(
      'should emit correct states when data is gotten successfully',
      build: () {
        arrangeUseCase();
        return buildCubit();
      },
      act: (cubit) => cubit.fetchMovieDetail(tId),
      expect: () => [
        const MovieDetailState(movieState: RequestState.Loading),
        MovieDetailState(
          movieState: RequestState.Loaded,
          movie: testMovieDetail,
          recommendationState: RequestState.Loading,
        ),
        MovieDetailState(
          movieState: RequestState.Loaded,
          movie: testMovieDetail,
          recommendationState: RequestState.Loaded,
          movieRecommendations: tMovies,
        ),
      ],
    );

    blocTest<MovieDetailCubit, MovieDetailState>(
      'should emit error when fetchMovieDetail fails',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tMovies));
        return buildCubit();
      },
      act: (cubit) => cubit.fetchMovieDetail(tId),
      expect: () => [
        const MovieDetailState(movieState: RequestState.Loading),
        const MovieDetailState(
          movieState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );

    blocTest<MovieDetailCubit, MovieDetailState>(
      'should emit error on recommendation when recommendation fetch fails',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(testMovieDetail));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Failed')));
        return buildCubit();
      },
      act: (cubit) => cubit.fetchMovieDetail(tId),
      expect: () => [
        const MovieDetailState(movieState: RequestState.Loading),
        MovieDetailState(
          movieState: RequestState.Loaded,
          movie: testMovieDetail,
          recommendationState: RequestState.Loading,
        ),
        MovieDetailState(
          movieState: RequestState.Loaded,
          movie: testMovieDetail,
          recommendationState: RequestState.Error,
          message: 'Failed',
        ),
      ],
    );
  });

  group('Watchlist', () {
    blocTest<MovieDetailCubit, MovieDetailState>(
      'should emit correct watchlist status',
      build: () {
        when(mockGetWatchListStatus.execute(1)).thenAnswer((_) async => true);
        return buildCubit();
      },
      act: (cubit) => cubit.loadWatchlistStatus(1),
      expect: () => [
        const MovieDetailState(isAddedToWatchlist: true),
      ],
    );

    blocTest<MovieDetailCubit, MovieDetailState>(
      'should emit success message when add watchlist succeeds',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Added to Watchlist'));
        when(mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        return buildCubit();
      },
      act: (cubit) => cubit.addWatchlist(testMovieDetail),
      expect: () => [
        const MovieDetailState(watchlistMessage: 'Added to Watchlist'),
        const MovieDetailState(
          watchlistMessage: 'Added to Watchlist',
          isAddedToWatchlist: true,
        ),
      ],
    );

    blocTest<MovieDetailCubit, MovieDetailState>(
      'should emit failure message when add watchlist fails',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return buildCubit();
      },
      act: (cubit) => cubit.addWatchlist(testMovieDetail),
      expect: () => [
        const MovieDetailState(watchlistMessage: 'Failed'),
      ],
    );

    blocTest<MovieDetailCubit, MovieDetailState>(
      'should emit success message when remove watchlist succeeds',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Removed from Watchlist'));
        when(mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return buildCubit();
      },
      act: (cubit) => cubit.removeFromWatchlist(testMovieDetail),
      expect: () => [
        const MovieDetailState(watchlistMessage: 'Removed from Watchlist'),
      ],
    );
  });
}
