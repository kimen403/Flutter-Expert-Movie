import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/tv_series/get_watchlist_status_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/save_watchlist_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'tv_series_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvSeriesDetail,
  GetTvSeriesRecommendations,
  GetWatchListStatusTvSeries,
  SaveWatchlistTvSeries,
  RemoveWatchlistTvSeries,
])
void main() {
  late MockGetTvSeriesDetail mockGetTvSeriesDetail;
  late MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;
  late MockGetWatchListStatusTvSeries mockGetWatchListStatus;
  late MockSaveWatchlistTvSeries mockSaveWatchlist;
  late MockRemoveWatchlistTvSeries mockRemoveWatchlist;

  setUp(() {
    mockGetTvSeriesDetail = MockGetTvSeriesDetail();
    mockGetTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    mockGetWatchListStatus = MockGetWatchListStatusTvSeries();
    mockSaveWatchlist = MockSaveWatchlistTvSeries();
    mockRemoveWatchlist = MockRemoveWatchlistTvSeries();
  });

  TvSeriesDetailCubit buildCubit() => TvSeriesDetailCubit(
        getTvSeriesDetail: mockGetTvSeriesDetail,
        getTvSeriesRecommendations: mockGetTvSeriesRecommendations,
        getWatchListStatus: mockGetWatchListStatus,
        saveWatchlist: mockSaveWatchlist,
        removeWatchlist: mockRemoveWatchlist,
      );

  final tId = 119051;
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

  group('fetchTvSeriesDetail', () {
    void arrangeUseCase() {
      when(mockGetTvSeriesDetail.execute(tId))
          .thenAnswer((_) async => Right(testTvSeriesDetail));
      when(mockGetTvSeriesRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tTvSeriesList));
    }

    blocTest<TvSeriesDetailCubit, TvSeriesDetailState>(
      'should emit correct states when data is gotten successfully',
      build: () {
        arrangeUseCase();
        return buildCubit();
      },
      act: (cubit) => cubit.fetchTvSeriesDetail(tId),
      expect: () => [
        const TvSeriesDetailState(tvSeriesState: RequestState.Loading),
        TvSeriesDetailState(
          tvSeriesState: RequestState.Loaded,
          tvSeries: testTvSeriesDetail,
          recommendationState: RequestState.Loading,
        ),
        TvSeriesDetailState(
          tvSeriesState: RequestState.Loaded,
          tvSeries: testTvSeriesDetail,
          recommendationState: RequestState.Loaded,
          tvSeriesRecommendations: tTvSeriesList,
        ),
      ],
    );

    blocTest<TvSeriesDetailCubit, TvSeriesDetailState>(
      'should emit error when fetchTvSeriesDetail fails',
      build: () {
        when(mockGetTvSeriesDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetTvSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tTvSeriesList));
        return buildCubit();
      },
      act: (cubit) => cubit.fetchTvSeriesDetail(tId),
      expect: () => [
        const TvSeriesDetailState(tvSeriesState: RequestState.Loading),
        const TvSeriesDetailState(
          tvSeriesState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );

    blocTest<TvSeriesDetailCubit, TvSeriesDetailState>(
      'should emit error on recommendation when recommendation fetch fails',
      build: () {
        when(mockGetTvSeriesDetail.execute(tId))
            .thenAnswer((_) async => Right(testTvSeriesDetail));
        when(mockGetTvSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Failed')));
        return buildCubit();
      },
      act: (cubit) => cubit.fetchTvSeriesDetail(tId),
      expect: () => [
        const TvSeriesDetailState(tvSeriesState: RequestState.Loading),
        TvSeriesDetailState(
          tvSeriesState: RequestState.Loaded,
          tvSeries: testTvSeriesDetail,
          recommendationState: RequestState.Loading,
        ),
        TvSeriesDetailState(
          tvSeriesState: RequestState.Loaded,
          tvSeries: testTvSeriesDetail,
          recommendationState: RequestState.Error,
          message: 'Failed',
        ),
      ],
    );
  });

  group('Watchlist', () {
    blocTest<TvSeriesDetailCubit, TvSeriesDetailState>(
      'should emit correct watchlist status',
      build: () {
        when(mockGetWatchListStatus.execute(1)).thenAnswer((_) async => true);
        return buildCubit();
      },
      act: (cubit) => cubit.loadWatchlistStatus(1),
      expect: () => [
        const TvSeriesDetailState(isAddedToWatchlist: true),
      ],
    );

    blocTest<TvSeriesDetailCubit, TvSeriesDetailState>(
      'should emit success message when add watchlist succeeds',
      build: () {
        when(mockSaveWatchlist.execute(testTvSeriesDetail))
            .thenAnswer((_) async => Right('Added to Watchlist'));
        when(mockGetWatchListStatus.execute(testTvSeriesDetail.id))
            .thenAnswer((_) async => true);
        return buildCubit();
      },
      act: (cubit) => cubit.addWatchlist(testTvSeriesDetail),
      expect: () => [
        const TvSeriesDetailState(watchlistMessage: 'Added to Watchlist'),
        const TvSeriesDetailState(
          watchlistMessage: 'Added to Watchlist',
          isAddedToWatchlist: true,
        ),
      ],
    );

    blocTest<TvSeriesDetailCubit, TvSeriesDetailState>(
      'should emit success message when remove watchlist succeeds',
      build: () {
        when(mockRemoveWatchlist.execute(testTvSeriesDetail))
            .thenAnswer((_) async => Right('Removed from Watchlist'));
        when(mockGetWatchListStatus.execute(testTvSeriesDetail.id))
            .thenAnswer((_) async => false);
        return buildCubit();
      },
      act: (cubit) => cubit.removeFromWatchlist(testTvSeriesDetail),
      expect: () => [
        const TvSeriesDetailState(watchlistMessage: 'Removed from Watchlist'),
      ],
    );
  });
}
