import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_popular_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series/popular_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTvSeries])
void main() {
  late MockGetPopularTvSeries mockGetPopularTvSeries;
  setUp(() => mockGetPopularTvSeries = MockGetPopularTvSeries());

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

  blocTest<PopularTvSeriesCubit, PopularTvSeriesState>(
    'should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));
      return PopularTvSeriesCubit(getPopularTvSeries: mockGetPopularTvSeries);
    },
    act: (cubit) => cubit.fetchPopularTvSeries(),
    expect: () => [
      const PopularTvSeriesState(state: RequestState.Loading),
      PopularTvSeriesState(state: RequestState.Loaded, tvSeries: tTvSeriesList),
    ],
  );

  blocTest<PopularTvSeriesCubit, PopularTvSeriesState>(
    'should emit [Loading, Error] when data is unsuccessful',
    build: () {
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return PopularTvSeriesCubit(getPopularTvSeries: mockGetPopularTvSeries);
    },
    act: (cubit) => cubit.fetchPopularTvSeries(),
    expect: () => [
      const PopularTvSeriesState(state: RequestState.Loading),
      const PopularTvSeriesState(
          state: RequestState.Error, message: 'Server Failure'),
    ],
  );
}
