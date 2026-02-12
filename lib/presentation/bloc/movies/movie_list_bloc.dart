import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/movies/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/movies/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/movies/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ── State ──────────────────────────────────────────────
class MovieListState extends Equatable {
  final RequestState state;
  final List<Movie> movies;
  final String message;

  const MovieListState({
    this.state = RequestState.Empty,
    this.movies = const [],
    this.message = '',
  });

  MovieListState copyWith({
    RequestState? state,
    List<Movie>? movies,
    String? message,
  }) {
    return MovieListState(
      state: state ?? this.state,
      movies: movies ?? this.movies,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, movies, message];
}

// ── Cubits ─────────────────────────────────────────────
class NowPlayingMoviesCubit extends Cubit<MovieListState> {
  final GetNowPlayingMovies getNowPlayingMovies;

  NowPlayingMoviesCubit({required this.getNowPlayingMovies})
      : super(const MovieListState());

  Future<void> fetchNowPlayingMovies() async {
    emit(state.copyWith(state: RequestState.Loading));
    final result = await getNowPlayingMovies.execute();
    result.fold(
      (failure) => emit(state.copyWith(
        state: RequestState.Error,
        message: failure.message,
      )),
      (movies) => emit(state.copyWith(
        state: RequestState.Loaded,
        movies: movies,
      )),
    );
  }
}

class PopularMoviesHomeCubit extends Cubit<MovieListState> {
  final GetPopularMovies getPopularMovies;

  PopularMoviesHomeCubit({required this.getPopularMovies})
      : super(const MovieListState());

  Future<void> fetchPopularMovies() async {
    emit(state.copyWith(state: RequestState.Loading));
    final result = await getPopularMovies.execute();
    result.fold(
      (failure) => emit(state.copyWith(
        state: RequestState.Error,
        message: failure.message,
      )),
      (movies) => emit(state.copyWith(
        state: RequestState.Loaded,
        movies: movies,
      )),
    );
  }
}

class TopRatedMoviesHomeCubit extends Cubit<MovieListState> {
  final GetTopRatedMovies getTopRatedMovies;

  TopRatedMoviesHomeCubit({required this.getTopRatedMovies})
      : super(const MovieListState());

  Future<void> fetchTopRatedMovies() async {
    emit(state.copyWith(state: RequestState.Loading));
    final result = await getTopRatedMovies.execute();
    result.fold(
      (failure) => emit(state.copyWith(
        state: RequestState.Error,
        message: failure.message,
      )),
      (movies) => emit(state.copyWith(
        state: RequestState.Loaded,
        movies: movies,
      )),
    );
  }
}
