import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/search_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series/search_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_tv_series_bloc_test.mocks.dart';

@GenerateMocks([SearchTvSeries])
void main() {
  late MockSearchTvSeries mockSearchTvSeries;
  setUp(() => mockSearchTvSeries = MockSearchTvSeries());

  final tTvSeries = TvSeries(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1],
    id: 1,
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    name: 'name',
    voteAverage: 1,
    voteCount: 1,
  );
  final tTvSeriesList = <TvSeries>[tTvSeries];
  final tQuery = 'wednesday';

  blocTest<SearchTvSeriesCubit, SearchTvSeriesState>(
    'should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockSearchTvSeries.execute(tQuery))
          .thenAnswer((_) async => Right(tTvSeriesList));
      return SearchTvSeriesCubit(searchTvSeries: mockSearchTvSeries);
    },
    act: (cubit) => cubit.fetchTvSeriesSearch(tQuery),
    expect: () => [
      const SearchTvSeriesState(state: RequestState.Loading),
      SearchTvSeriesState(
          state: RequestState.Loaded, searchResult: tTvSeriesList),
    ],
  );

  blocTest<SearchTvSeriesCubit, SearchTvSeriesState>(
    'should emit [Loading, Error] when data is unsuccessful',
    build: () {
      when(mockSearchTvSeries.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return SearchTvSeriesCubit(searchTvSeries: mockSearchTvSeries);
    },
    act: (cubit) => cubit.fetchTvSeriesSearch(tQuery),
    expect: () => [
      const SearchTvSeriesState(state: RequestState.Loading),
      const SearchTvSeriesState(
          state: RequestState.Error, message: 'Server Failure'),
    ],
  );
}
