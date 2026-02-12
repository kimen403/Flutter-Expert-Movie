import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/movies/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ── State ──────────────────────────────────────────────
class TopRatedMoviesState extends Equatable {
  final RequestState state;
  final List<Movie> movies;
  final String message;

  const TopRatedMoviesState({
    this.state = RequestState.Empty,
    this.movies = const [],
    this.message = '',
  });

  TopRatedMoviesState copyWith({
    RequestState? state,
    List<Movie>? movies,
    String? message,
  }) {
    return TopRatedMoviesState(
      state: state ?? this.state,
      movies: movies ?? this.movies,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, movies, message];
}

// ── Cubit ──────────────────────────────────────────────
class TopRatedMoviesCubit extends Cubit<TopRatedMoviesState> {
  final GetTopRatedMovies getTopRatedMovies;

  TopRatedMoviesCubit({required this.getTopRatedMovies})
      : super(const TopRatedMoviesState());

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
