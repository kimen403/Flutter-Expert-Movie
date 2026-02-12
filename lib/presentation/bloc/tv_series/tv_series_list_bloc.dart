import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_now_playing_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_top_rated_tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ── State ──────────────────────────────────────────────
class TvSeriesListState extends Equatable {
  final RequestState state;
  final List<TvSeries> tvSeries;
  final String message;

  const TvSeriesListState({
    this.state = RequestState.Empty,
    this.tvSeries = const [],
    this.message = '',
  });

  TvSeriesListState copyWith({
    RequestState? state,
    List<TvSeries>? tvSeries,
    String? message,
  }) {
    return TvSeriesListState(
      state: state ?? this.state,
      tvSeries: tvSeries ?? this.tvSeries,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, tvSeries, message];
}

// ── Cubits ─────────────────────────────────────────────
class NowPlayingTvSeriesCubit extends Cubit<TvSeriesListState> {
  final GetNowPlayingTvSeries getNowPlayingTvSeries;

  NowPlayingTvSeriesCubit({required this.getNowPlayingTvSeries})
      : super(const TvSeriesListState());

  Future<void> fetchNowPlayingTvSeries() async {
    emit(state.copyWith(state: RequestState.Loading));
    final result = await getNowPlayingTvSeries.execute();
    result.fold(
      (failure) => emit(state.copyWith(
        state: RequestState.Error,
        message: failure.message,
      )),
      (tvSeries) => emit(state.copyWith(
        state: RequestState.Loaded,
        tvSeries: tvSeries,
      )),
    );
  }
}

class PopularTvSeriesHomeCubit extends Cubit<TvSeriesListState> {
  final GetPopularTvSeries getPopularTvSeries;

  PopularTvSeriesHomeCubit({required this.getPopularTvSeries})
      : super(const TvSeriesListState());

  Future<void> fetchPopularTvSeries() async {
    emit(state.copyWith(state: RequestState.Loading));
    final result = await getPopularTvSeries.execute();
    result.fold(
      (failure) => emit(state.copyWith(
        state: RequestState.Error,
        message: failure.message,
      )),
      (tvSeries) => emit(state.copyWith(
        state: RequestState.Loaded,
        tvSeries: tvSeries,
      )),
    );
  }
}

class TopRatedTvSeriesHomeCubit extends Cubit<TvSeriesListState> {
  final GetTopRatedTvSeries getTopRatedTvSeries;

  TopRatedTvSeriesHomeCubit({required this.getTopRatedTvSeries})
      : super(const TvSeriesListState());

  Future<void> fetchTopRatedTvSeries() async {
    emit(state.copyWith(state: RequestState.Loading));
    final result = await getTopRatedTvSeries.execute();
    result.fold(
      (failure) => emit(state.copyWith(
        state: RequestState.Error,
        message: failure.message,
      )),
      (tvSeries) => emit(state.copyWith(
        state: RequestState.Loaded,
        tvSeries: tvSeries,
      )),
    );
  }
}
