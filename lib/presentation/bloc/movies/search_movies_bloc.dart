import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/movies/search_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ── State ──────────────────────────────────────────────
class SearchMoviesState extends Equatable {
  final RequestState state;
  final List<Movie> searchResult;
  final String message;

  const SearchMoviesState({
    this.state = RequestState.Empty,
    this.searchResult = const [],
    this.message = '',
  });

  SearchMoviesState copyWith({
    RequestState? state,
    List<Movie>? searchResult,
    String? message,
  }) {
    return SearchMoviesState(
      state: state ?? this.state,
      searchResult: searchResult ?? this.searchResult,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, searchResult, message];
}

// ── Cubit ──────────────────────────────────────────────
class SearchMoviesCubit extends Cubit<SearchMoviesState> {
  final SearchMovies searchMovies;

  SearchMoviesCubit({required this.searchMovies})
      : super(const SearchMoviesState());

  Future<void> fetchMovieSearch(String query) async {
    emit(state.copyWith(state: RequestState.Loading));
    final result = await searchMovies.execute(query);
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
