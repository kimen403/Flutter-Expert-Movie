import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/movies/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/movies/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/movies/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/movies/movie_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_list_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies, GetPopularMovies, GetTopRatedMovies])
void main() {
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

  group('NowPlayingMoviesCubit', () {
    late MockGetNowPlayingMovies mockGetNowPlayingMovies;

    setUp(() {
      mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    });

    blocTest<NowPlayingMoviesCubit, MovieListState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return NowPlayingMoviesCubit(
            getNowPlayingMovies: mockGetNowPlayingMovies);
      },
      act: (cubit) => cubit.fetchNowPlayingMovies(),
      expect: () => [
        const MovieListState(state: RequestState.Loading),
        MovieListState(state: RequestState.Loaded, movies: tMovieList),
      ],
    );

    blocTest<NowPlayingMoviesCubit, MovieListState>(
      'should emit [Loading, Error] when data is unsuccessful',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return NowPlayingMoviesCubit(
            getNowPlayingMovies: mockGetNowPlayingMovies);
      },
      act: (cubit) => cubit.fetchNowPlayingMovies(),
      expect: () => [
        const MovieListState(state: RequestState.Loading),
        const MovieListState(
            state: RequestState.Error, message: 'Server Failure'),
      ],
    );
  });

  group('PopularMoviesHomeCubit', () {
    late MockGetPopularMovies mockGetPopularMovies;

    setUp(() {
      mockGetPopularMovies = MockGetPopularMovies();
    });

    blocTest<PopularMoviesHomeCubit, MovieListState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return PopularMoviesHomeCubit(getPopularMovies: mockGetPopularMovies);
      },
      act: (cubit) => cubit.fetchPopularMovies(),
      expect: () => [
        const MovieListState(state: RequestState.Loading),
        MovieListState(state: RequestState.Loaded, movies: tMovieList),
      ],
    );

    blocTest<PopularMoviesHomeCubit, MovieListState>(
      'should emit [Loading, Error] when data is unsuccessful',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return PopularMoviesHomeCubit(getPopularMovies: mockGetPopularMovies);
      },
      act: (cubit) => cubit.fetchPopularMovies(),
      expect: () => [
        const MovieListState(state: RequestState.Loading),
        const MovieListState(
            state: RequestState.Error, message: 'Server Failure'),
      ],
    );
  });

  group('TopRatedMoviesHomeCubit', () {
    late MockGetTopRatedMovies mockGetTopRatedMovies;

    setUp(() {
      mockGetTopRatedMovies = MockGetTopRatedMovies();
    });

    blocTest<TopRatedMoviesHomeCubit, MovieListState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return TopRatedMoviesHomeCubit(
            getTopRatedMovies: mockGetTopRatedMovies);
      },
      act: (cubit) => cubit.fetchTopRatedMovies(),
      expect: () => [
        const MovieListState(state: RequestState.Loading),
        MovieListState(state: RequestState.Loaded, movies: tMovieList),
      ],
    );

    blocTest<TopRatedMoviesHomeCubit, MovieListState>(
      'should emit [Loading, Error] when data is unsuccessful',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return TopRatedMoviesHomeCubit(
            getTopRatedMovies: mockGetTopRatedMovies);
      },
      act: (cubit) => cubit.fetchTopRatedMovies(),
      expect: () => [
        const MovieListState(state: RequestState.Loading),
        const MovieListState(
            state: RequestState.Error, message: 'Server Failure'),
      ],
    );
  });
}
