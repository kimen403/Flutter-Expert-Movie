import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_now_playing_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_list_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingTvSeries, GetPopularTvSeries, GetTopRatedTvSeries])
void main() {
  final tTvSeries = TvSeries(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
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

  group('NowPlayingTvSeriesCubit', () {
    late MockGetNowPlayingTvSeries mockGetNowPlayingTvSeries;
    setUp(() {
      mockGetNowPlayingTvSeries = MockGetNowPlayingTvSeries();
    });

    blocTest<NowPlayingTvSeriesCubit, TvSeriesListState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetNowPlayingTvSeries.execute())
            .thenAnswer((_) async => Right(tTvSeriesList));
        return NowPlayingTvSeriesCubit(
            getNowPlayingTvSeries: mockGetNowPlayingTvSeries);
      },
      act: (cubit) => cubit.fetchNowPlayingTvSeries(),
      expect: () => [
        const TvSeriesListState(state: RequestState.Loading),
        TvSeriesListState(state: RequestState.Loaded, tvSeries: tTvSeriesList),
      ],
    );

    blocTest<NowPlayingTvSeriesCubit, TvSeriesListState>(
      'should emit [Loading, Error] when data is unsuccessful',
      build: () {
        when(mockGetNowPlayingTvSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return NowPlayingTvSeriesCubit(
            getNowPlayingTvSeries: mockGetNowPlayingTvSeries);
      },
      act: (cubit) => cubit.fetchNowPlayingTvSeries(),
      expect: () => [
        const TvSeriesListState(state: RequestState.Loading),
        const TvSeriesListState(
            state: RequestState.Error, message: 'Server Failure'),
      ],
    );
  });

  group('PopularTvSeriesHomeCubit', () {
    late MockGetPopularTvSeries mockGetPopularTvSeries;
    setUp(() {
      mockGetPopularTvSeries = MockGetPopularTvSeries();
    });

    blocTest<PopularTvSeriesHomeCubit, TvSeriesListState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetPopularTvSeries.execute())
            .thenAnswer((_) async => Right(tTvSeriesList));
        return PopularTvSeriesHomeCubit(
            getPopularTvSeries: mockGetPopularTvSeries);
      },
      act: (cubit) => cubit.fetchPopularTvSeries(),
      expect: () => [
        const TvSeriesListState(state: RequestState.Loading),
        TvSeriesListState(state: RequestState.Loaded, tvSeries: tTvSeriesList),
      ],
    );

    blocTest<PopularTvSeriesHomeCubit, TvSeriesListState>(
      'should emit [Loading, Error] when data is unsuccessful',
      build: () {
        when(mockGetPopularTvSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return PopularTvSeriesHomeCubit(
            getPopularTvSeries: mockGetPopularTvSeries);
      },
      act: (cubit) => cubit.fetchPopularTvSeries(),
      expect: () => [
        const TvSeriesListState(state: RequestState.Loading),
        const TvSeriesListState(
            state: RequestState.Error, message: 'Server Failure'),
      ],
    );
  });

  group('TopRatedTvSeriesHomeCubit', () {
    late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;
    setUp(() {
      mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    });

    blocTest<TopRatedTvSeriesHomeCubit, TvSeriesListState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetTopRatedTvSeries.execute())
            .thenAnswer((_) async => Right(tTvSeriesList));
        return TopRatedTvSeriesHomeCubit(
            getTopRatedTvSeries: mockGetTopRatedTvSeries);
      },
      act: (cubit) => cubit.fetchTopRatedTvSeries(),
      expect: () => [
        const TvSeriesListState(state: RequestState.Loading),
        TvSeriesListState(state: RequestState.Loaded, tvSeries: tTvSeriesList),
      ],
    );

    blocTest<TopRatedTvSeriesHomeCubit, TvSeriesListState>(
      'should emit [Loading, Error] when data is unsuccessful',
      build: () {
        when(mockGetTopRatedTvSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return TopRatedTvSeriesHomeCubit(
            getTopRatedTvSeries: mockGetTopRatedTvSeries);
      },
      act: (cubit) => cubit.fetchTopRatedTvSeries(),
      expect: () => [
        const TvSeriesListState(state: RequestState.Loading),
        const TvSeriesListState(
            state: RequestState.Error, message: 'Server Failure'),
      ],
    );
  });
}
