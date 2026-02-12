import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/movies/get_popular_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ── State ──────────────────────────────────────────────
class PopularMoviesState extends Equatable {
  final RequestState state;
  final List<Movie> movies;
  final String message;

  const PopularMoviesState({
    this.state = RequestState.Empty,
    this.movies = const [],
    this.message = '',
  });

  PopularMoviesState copyWith({
    RequestState? state,
    List<Movie>? movies,
    String? message,
  }) {
    return PopularMoviesState(
      state: state ?? this.state,
      movies: movies ?? this.movies,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, movies, message];
}

// ── Cubit ──────────────────────────────────────────────
class PopularMoviesCubit extends Cubit<PopularMoviesState> {
  final GetPopularMovies getPopularMovies;

  PopularMoviesCubit({required this.getPopularMovies})
      : super(const PopularMoviesState());

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
