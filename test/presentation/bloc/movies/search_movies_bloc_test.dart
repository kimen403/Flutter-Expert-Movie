import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/movies/search_movies.dart';
import 'package:ditonton/presentation/bloc/movies/search_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_movies_bloc_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main() {
  late MockSearchMovies mockSearchMovies;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
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
  final tQuery = 'spiderman';

  blocTest<SearchMoviesCubit, SearchMoviesState>(
    'should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Right(tMovieList));
      return SearchMoviesCubit(searchMovies: mockSearchMovies);
    },
    act: (cubit) => cubit.fetchMovieSearch(tQuery),
    expect: () => [
      const SearchMoviesState(state: RequestState.Loading),
      SearchMoviesState(state: RequestState.Loaded, searchResult: tMovieList),
    ],
  );

  blocTest<SearchMoviesCubit, SearchMoviesState>(
    'should emit [Loading, Error] when data is unsuccessful',
    build: () {
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return SearchMoviesCubit(searchMovies: mockSearchMovies);
    },
    act: (cubit) => cubit.fetchMovieSearch(tQuery),
    expect: () => [
      const SearchMoviesState(state: RequestState.Loading),
      const SearchMoviesState(
          state: RequestState.Error, message: 'Server Failure'),
    ],
  );
}
