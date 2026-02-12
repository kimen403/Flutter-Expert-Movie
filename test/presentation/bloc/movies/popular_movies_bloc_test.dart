import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/movies/get_popular_movies.dart';
import 'package:ditonton/presentation/bloc/movies/popular_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_movies_bloc_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late MockGetPopularMovies mockGetPopularMovies;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
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

  blocTest<PopularMoviesCubit, PopularMoviesState>(
    'should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return PopularMoviesCubit(getPopularMovies: mockGetPopularMovies);
    },
    act: (cubit) => cubit.fetchPopularMovies(),
    expect: () => [
      const PopularMoviesState(state: RequestState.Loading),
      PopularMoviesState(state: RequestState.Loaded, movies: tMovieList),
    ],
  );

  blocTest<PopularMoviesCubit, PopularMoviesState>(
    'should emit [Loading, Error] when data is unsuccessful',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return PopularMoviesCubit(getPopularMovies: mockGetPopularMovies);
    },
    act: (cubit) => cubit.fetchPopularMovies(),
    expect: () => [
      const PopularMoviesState(state: RequestState.Loading),
      const PopularMoviesState(
          state: RequestState.Error, message: 'Server Failure'),
    ],
  );
}
