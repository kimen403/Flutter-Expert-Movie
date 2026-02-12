import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_watchlist_tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ── State ──────────────────────────────────────────────
class WatchlistTvSeriesState extends Equatable {
  final RequestState watchlistState;
  final List<TvSeries> watchlistTvSeries;
  final String message;

  const WatchlistTvSeriesState({
    this.watchlistState = RequestState.Empty,
    this.watchlistTvSeries = const [],
    this.message = '',
  });

  WatchlistTvSeriesState copyWith({
    RequestState? watchlistState,
    List<TvSeries>? watchlistTvSeries,
    String? message,
  }) {
    return WatchlistTvSeriesState(
      watchlistState: watchlistState ?? this.watchlistState,
      watchlistTvSeries: watchlistTvSeries ?? this.watchlistTvSeries,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [watchlistState, watchlistTvSeries, message];
}

// ── Cubit ──────────────────────────────────────────────
class WatchlistTvSeriesCubit extends Cubit<WatchlistTvSeriesState> {
  final GetWatchlistTvSeries getWatchlistTvSeries;

  WatchlistTvSeriesCubit({required this.getWatchlistTvSeries})
      : super(const WatchlistTvSeriesState());

  Future<void> fetchWatchlistTvSeries() async {
    emit(state.copyWith(watchlistState: RequestState.Loading));
    final result = await getWatchlistTvSeries.execute();
    result.fold(
      (failure) => emit(state.copyWith(
        watchlistState: RequestState.Error,
        message: failure.message,
      )),
      (tvSeries) => emit(state.copyWith(
        watchlistState: RequestState.Loaded,
        watchlistTvSeries: tvSeries,
      )),
    );
  }
}
