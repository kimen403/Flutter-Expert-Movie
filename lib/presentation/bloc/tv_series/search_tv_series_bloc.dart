import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/search_tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ── State ──────────────────────────────────────────────
class SearchTvSeriesState extends Equatable {
  final RequestState state;
  final List<TvSeries> searchResult;
  final String message;

  const SearchTvSeriesState({
    this.state = RequestState.Empty,
    this.searchResult = const [],
    this.message = '',
  });

  SearchTvSeriesState copyWith({
    RequestState? state,
    List<TvSeries>? searchResult,
    String? message,
  }) {
    return SearchTvSeriesState(
      state: state ?? this.state,
      searchResult: searchResult ?? this.searchResult,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, searchResult, message];
}

// ── Cubit ──────────────────────────────────────────────
class SearchTvSeriesCubit extends Cubit<SearchTvSeriesState> {
  final SearchTvSeries searchTvSeries;

  SearchTvSeriesCubit({required this.searchTvSeries})
      : super(const SearchTvSeriesState());

  Future<void> fetchTvSeriesSearch(String query) async {
    emit(state.copyWith(state: RequestState.Loading));
    final result = await searchTvSeries.execute(query);
    result.fold(
      (failure) => emit(state.copyWith(
        state: RequestState.Error,
        message: failure.message,
      )),
      (data) => emit(state.copyWith(
        state: RequestState.Loaded,
        searchResult: data,
      )),
    );
  }
}
