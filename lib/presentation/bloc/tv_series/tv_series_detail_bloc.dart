import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/tv_series/get_watchlist_status_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/save_watchlist_tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ── State ──────────────────────────────────────────────
class TvSeriesDetailState extends Equatable {
  final RequestState tvSeriesState;
  final TvSeriesDetail? tvSeries;
  final RequestState recommendationState;
  final List<TvSeries> tvSeriesRecommendations;
  final bool isAddedToWatchlist;
  final String message;
  final String watchlistMessage;

  const TvSeriesDetailState({
    this.tvSeriesState = RequestState.Empty,
    this.tvSeries,
    this.recommendationState = RequestState.Empty,
    this.tvSeriesRecommendations = const [],
    this.isAddedToWatchlist = false,
    this.message = '',
    this.watchlistMessage = '',
  });

  TvSeriesDetailState copyWith({
    RequestState? tvSeriesState,
    TvSeriesDetail? tvSeries,
    RequestState? recommendationState,
    List<TvSeries>? tvSeriesRecommendations,
    bool? isAddedToWatchlist,
    String? message,
    String? watchlistMessage,
  }) {
    return TvSeriesDetailState(
      tvSeriesState: tvSeriesState ?? this.tvSeriesState,
      tvSeries: tvSeries ?? this.tvSeries,
      recommendationState: recommendationState ?? this.recommendationState,
      tvSeriesRecommendations:
          tvSeriesRecommendations ?? this.tvSeriesRecommendations,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      message: message ?? this.message,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
        tvSeriesState,
        tvSeries,
        recommendationState,
        tvSeriesRecommendations,
        isAddedToWatchlist,
        message,
        watchlistMessage,
      ];
}

// ── Cubit ──────────────────────────────────────────────
class TvSeriesDetailCubit extends Cubit<TvSeriesDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations getTvSeriesRecommendations;
  final GetWatchListStatusTvSeries getWatchListStatus;
  final SaveWatchlistTvSeries saveWatchlist;
  final RemoveWatchlistTvSeries removeWatchlist;

  TvSeriesDetailCubit({
    required this.getTvSeriesDetail,
    required this.getTvSeriesRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(const TvSeriesDetailState());

  Future<void> fetchTvSeriesDetail(int id) async {
    emit(state.copyWith(tvSeriesState: RequestState.Loading));
    final detailResult = await getTvSeriesDetail.execute(id);
    final recommendationResult = await getTvSeriesRecommendations.execute(id);

    detailResult.fold(
      (failure) {
        emit(state.copyWith(
          tvSeriesState: RequestState.Error,
          message: failure.message,
        ));
      },
      (tvSeries) {
        emit(state.copyWith(
          tvSeriesState: RequestState.Loaded,
          tvSeries: tvSeries,
          recommendationState: RequestState.Loading,
        ));
        recommendationResult.fold(
          (failure) {
            emit(state.copyWith(
              recommendationState: RequestState.Error,
              message: failure.message,
            ));
          },
          (tvSeriesList) {
            emit(state.copyWith(
              recommendationState: RequestState.Loaded,
              tvSeriesRecommendations: tvSeriesList,
            ));
          },
        );
      },
    );
  }

  Future<void> addWatchlist(TvSeriesDetail tvSeries) async {
    final result = await saveWatchlist.execute(tvSeries);
    await result.fold(
      (failure) async {
        emit(state.copyWith(watchlistMessage: failure.message));
      },
      (successMessage) async {
        emit(state.copyWith(watchlistMessage: successMessage));
      },
    );
    await loadWatchlistStatus(tvSeries.id);
  }

  Future<void> removeFromWatchlist(TvSeriesDetail tvSeries) async {
    final result = await removeWatchlist.execute(tvSeries);
    await result.fold(
      (failure) async {
        emit(state.copyWith(watchlistMessage: failure.message));
      },
      (successMessage) async {
        emit(state.copyWith(watchlistMessage: successMessage));
      },
    );
    await loadWatchlistStatus(tvSeries.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatus.execute(id);
    emit(state.copyWith(isAddedToWatchlist: result));
  }
}
