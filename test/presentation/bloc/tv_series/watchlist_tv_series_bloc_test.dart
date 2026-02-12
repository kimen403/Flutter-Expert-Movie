import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_watchlist_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series/watchlist_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watchlist_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTvSeries])
void main() {
  late MockGetWatchlistTvSeries mockGetWatchlistTvSeries;
  setUp(() => mockGetWatchlistTvSeries = MockGetWatchlistTvSeries());

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

  blocTest<WatchlistTvSeriesCubit, WatchlistTvSeriesState>(
    'should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));
      return WatchlistTvSeriesCubit(
          getWatchlistTvSeries: mockGetWatchlistTvSeries);
    },
    act: (cubit) => cubit.fetchWatchlistTvSeries(),
    expect: () => [
      const WatchlistTvSeriesState(watchlistState: RequestState.Loading),
      WatchlistTvSeriesState(
          watchlistState: RequestState.Loaded,
          watchlistTvSeries: tTvSeriesList),
    ],
  );

  blocTest<WatchlistTvSeriesCubit, WatchlistTvSeriesState>(
    'should emit [Loading, Error] when data is unsuccessful',
    build: () {
      when(mockGetWatchlistTvSeries.execute())
          .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
      return WatchlistTvSeriesCubit(
          getWatchlistTvSeries: mockGetWatchlistTvSeries);
    },
    act: (cubit) => cubit.fetchWatchlistTvSeries(),
    expect: () => [
      const WatchlistTvSeriesState(watchlistState: RequestState.Loading),
      const WatchlistTvSeriesState(
          watchlistState: RequestState.Error, message: 'Database Failure'),
    ],
  );
}
