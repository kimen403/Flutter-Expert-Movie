import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/movies/get_watchlist_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ── State ──────────────────────────────────────────────
class WatchlistMovieState extends Equatable {
  final RequestState watchlistState;
  final List<Movie> watchlistMovies;
  final String message;

  const WatchlistMovieState({
    this.watchlistState = RequestState.Empty,
    this.watchlistMovies = const [],
    this.message = '',
  });

  WatchlistMovieState copyWith({
    RequestState? watchlistState,
    List<Movie>? watchlistMovies,
    String? message,
  }) {
    return WatchlistMovieState(
      watchlistState: watchlistState ?? this.watchlistState,
      watchlistMovies: watchlistMovies ?? this.watchlistMovies,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [watchlistState, watchlistMovies, message];
}

// ── Cubit ──────────────────────────────────────────────
class WatchlistMovieCubit extends Cubit<WatchlistMovieState> {
  final GetWatchlistMovies getWatchlistMovies;

  WatchlistMovieCubit({required this.getWatchlistMovies})
      : super(const WatchlistMovieState());

  Future<void> fetchWatchlistMovies() async {
    emit(state.copyWith(watchlistState: RequestState.Loading));
    final result = await getWatchlistMovies.execute();
    result.fold(
      (failure) => emit(state.copyWith(
        watchlistState: RequestState.Error,
        message: failure.message,
      )),
      (movies) => emit(state.copyWith(
        watchlistState: RequestState.Loaded,
        watchlistMovies: movies,
      )),
    );
  }
}
