import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series/top_rated_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTvSeries])
void main() {
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;
  setUp(() => mockGetTopRatedTvSeries = MockGetTopRatedTvSeries());

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

  blocTest<TopRatedTvSeriesCubit, TopRatedTvSeriesState>(
    'should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));
      return TopRatedTvSeriesCubit(
          getTopRatedTvSeries: mockGetTopRatedTvSeries);
    },
    act: (cubit) => cubit.fetchTopRatedTvSeries(),
    expect: () => [
      const TopRatedTvSeriesState(state: RequestState.Loading),
      TopRatedTvSeriesState(
          state: RequestState.Loaded, tvSeries: tTvSeriesList),
    ],
  );

  blocTest<TopRatedTvSeriesCubit, TopRatedTvSeriesState>(
    'should emit [Loading, Error] when data is unsuccessful',
    build: () {
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return TopRatedTvSeriesCubit(
          getTopRatedTvSeries: mockGetTopRatedTvSeries);
    },
    act: (cubit) => cubit.fetchTopRatedTvSeries(),
    expect: () => [
      const TopRatedTvSeriesState(state: RequestState.Loading),
      const TopRatedTvSeriesState(
          state: RequestState.Error, message: 'Server Failure'),
    ],
  );
}
