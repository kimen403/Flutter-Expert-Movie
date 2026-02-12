import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/movies/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/movies/top_rated_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_movies_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
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

  blocTest<TopRatedMoviesCubit, TopRatedMoviesState>(
    'should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return TopRatedMoviesCubit(getTopRatedMovies: mockGetTopRatedMovies);
    },
    act: (cubit) => cubit.fetchTopRatedMovies(),
    expect: () => [
      const TopRatedMoviesState(state: RequestState.Loading),
      TopRatedMoviesState(state: RequestState.Loaded, movies: tMovieList),
    ],
  );

  blocTest<TopRatedMoviesCubit, TopRatedMoviesState>(
    'should emit [Loading, Error] when data is unsuccessful',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return TopRatedMoviesCubit(getTopRatedMovies: mockGetTopRatedMovies);
    },
    act: (cubit) => cubit.fetchTopRatedMovies(),
    expect: () => [
      const TopRatedMoviesState(state: RequestState.Loading),
      const TopRatedMoviesState(
          state: RequestState.Error, message: 'Server Failure'),
    ],
  );
}
