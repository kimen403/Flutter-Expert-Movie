import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/movies/get_watchlist_movies.dart';
import 'package:ditonton/presentation/bloc/movies/watchlist_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watchlist_movie_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
  });

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
  final tMovieList = <Movie>[tMovie];

  blocTest<WatchlistMovieCubit, WatchlistMovieState>(
    'should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return WatchlistMovieCubit(getWatchlistMovies: mockGetWatchlistMovies);
    },
    act: (cubit) => cubit.fetchWatchlistMovies(),
    expect: () => [
      const WatchlistMovieState(watchlistState: RequestState.Loading),
      WatchlistMovieState(
          watchlistState: RequestState.Loaded, watchlistMovies: tMovieList),
    ],
  );

  blocTest<WatchlistMovieCubit, WatchlistMovieState>(
    'should emit [Loading, Error] when data is unsuccessful',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
      return WatchlistMovieCubit(getWatchlistMovies: mockGetWatchlistMovies);
    },
    act: (cubit) => cubit.fetchWatchlistMovies(),
    expect: () => [
      const WatchlistMovieState(watchlistState: RequestState.Loading),
      const WatchlistMovieState(
          watchlistState: RequestState.Error, message: 'Database Failure'),
    ],
  );
}
