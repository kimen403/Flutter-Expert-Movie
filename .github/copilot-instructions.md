# Copilot Instructions for Ditonton TV Series/Movie App

## Architecture Overview

This Flutter app follows **Clean Architecture** with three distinct layers:

- **Presentation**: Provider-based state management with ChangeNotifier
- **Domain**: Business logic with Use Cases and Entities
- **Data**: Repository pattern with remote (TMDB API) and local (Hive) data sources

## Key Patterns & Conventions

### Presentation Layer (Provider Pattern)

#### Provider Structure

```dart
class MovieListNotifier extends ChangeNotifier {
  // Separate state and data getters
  RequestState get nowPlayingState => _nowPlayingState;
  List<Movie> get nowPlayingMovies => _nowPlayingMovies;

  // Private fields with underscore
  RequestState _nowPlayingState = RequestState.Empty;
  List<Movie> _nowPlayingMovies = [];
  String _message = '';

  // Constructor with required dependencies
  MovieListNotifier({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getTopRatedMovies,
  });

  // Always call notifyListeners() after state changes
  Future<void> fetchNowPlayingMovies() async {
    _nowPlayingState = RequestState.Loading;
    notifyListeners();

    final result = await getNowPlayingMovies.execute();
    result.fold(
      (failure) {
        _nowPlayingState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (moviesData) {
        _nowPlayingState = RequestState.Loaded;
        _nowPlayingMovies = moviesData;
        notifyListeners();
      },
    );
  }
}
```

#### RequestState Enum Usage

Always use the RequestState enum for UI state management:

```dart
enum RequestState { Empty, Loading, Loaded, Error }
```

### Domain Layer (Business Logic)

#### Use Case Pattern

```dart
class GetNowPlayingMovies {
  final MovieRepository repository;

  GetNowPlayingMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return repository.getNowPlayingMovies();
  }
}
```

#### Entity Pattern

```dart
class Movie extends Equatable {
  // Required constructor for full object
  Movie({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  // Factory constructor for watchlist (minimal fields)
  Movie.watchlist({
    required this.id,
    required this.overview,
    required this.posterPath,
    required this.title,
  });

  // All fields nullable except required ones
  bool? adult;
  String? backdropPath;
  List<int>? genreIds;
  int id;
  String originalTitle;
  String overview;
  double popularity;
  String? posterPath;
  String? releaseDate;
  String title;
  bool video;
  double voteAverage;
  int voteCount;

  @override
  List<Object?> get props => [
        adult,
        backdropPath,
        genreIds,
        id,
        originalTitle,
        overview,
        popularity,
        posterPath,
        releaseDate,
        title,
        video,
        voteAverage,
        voteCount,
      ];
}
```

#### Repository Interface Pattern

```dart
abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies();
  Future<Either<Failure, List<Movie>>> getPopularMovies();
  Future<Either<Failure, List<Movie>>> getTopRatedMovies();
  Future<Either<Failure, MovieDetail>> getMovieDetail(int id);
  Future<Either<Failure, List<Movie>>> getMovieRecommendations(int id);
  Future<Either<Failure, List<Movie>>> searchMovies(String query);
  Future<Either<Failure, String>> saveWatchlist(MovieDetail movie);
  Future<Either<Failure, String>> removeWatchlist(MovieDetail movie);
  Future<bool> isAddedToWatchlist(int id);
  Future<Either<Failure, List<Movie>>> getWatchlistMovies();
}
```

### Data Layer (Repository Implementation)

#### Repository Implementation Pattern

```dart
class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource;

  MovieRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies() async {
    try {
      final result = await remoteDataSource.getNowPlayingMovies();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }
}
```

#### Data Source Patterns

**Remote Data Source:**

```dart
abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getNowPlayingMovies();
  Future<List<MovieModel>> getPopularMovies();
  Future<MovieDetailResponse> getMovieDetail(int id);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  static const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  static const BASE_URL = 'https://api.themoviedb.org/3';

  final http.Client client;

  MovieRemoteDataSourceImpl({required this.client});

  @override
  Future<List<MovieModel>> getNowPlayingMovies() async {
    final response =
        await client.get(Uri.parse('$BASE_URL/movie/now_playing?$API_KEY'));

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException(response.body);
    }
  }
}
```

**Local Data Source:**

```dart
abstract class MovieLocalDataSource {
  Future<String> insertWatchlist(MovieTable movie);
  Future<String> removeWatchlist(MovieTable movie);
  Future<MovieTable?> getMovieById(int id);
  Future<List<MovieTable>> getWatchlistMovies();
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final DatabaseHelper databaseHelper;
  static const String _boxName = 'watchlist_movies';

  MovieLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertWatchlist(MovieTable movie) async {
    try {
      final success = await databaseHelper.insert(_boxName, movie.id, movie);
      if (success) {
        return 'Added to Watchlist';
      } else {
        throw DatabaseException('Failed to add movie to watchlist');
      }
    } catch (e) {
      throw DatabaseException('Error adding to watchlist: ${e.toString()}');
    }
  }
}
```

#### Model Pattern

```dart
class MovieModel extends Equatable {
  MovieModel({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  final bool adult;
  final String? backdropPath;
  final List<int> genreIds;
  final int id;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String? posterPath;
  final String? releaseDate;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        id: json["id"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"].toDouble(),
        posterPath: json["poster_path"],
        releaseDate: json["release_date"],
        title: json["title"],
        video: json["video"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "id": id,
        "original_title": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "release_date": releaseDate,
        "title": title,
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
      };

  Movie toEntity() {
    return Movie(
      adult: adult,
      backdropPath: backdropPath,
      genreIds: genreIds,
      id: id,
      originalTitle: originalTitle,
      overview: overview,
      popularity: popularity,
      posterPath: posterPath,
      releaseDate: releaseDate,
      title: title,
      video: video,
      voteAverage: voteAverage,
      voteCount: voteCount,
    );
  }

  @override
  List<Object?> get props => [
        adult,
        backdropPath,
        genreIds,
        id,
        originalTitle,
        overview,
        popularity,
        posterPath,
        releaseDate,
        title,
        video,
        voteAverage,
        voteCount,
      ];
}
```

### Dependency Injection (GetIt Pattern)

#### Registration Patterns

```dart
void init() {
  // External dependencies
  locator.registerLazySingleton(() => http.Client());

  // Data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(client: locator()),
  );
  locator.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(databaseHelper: locator()),
  );

  // Repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // Use cases (Lazy Singleton)
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));

  // Providers (Factory - new instance each time)
  locator.registerFactory(
    () => MovieListNotifier(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );
}
```

### Database Helper (Hive Pattern)

#### Singleton Database Helper

```dart
class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  DatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

  static final Map<String, Box<Map>> _boxes = {};

  Future<Box<Map>> _getBox(String boxName) async {
    if (_boxes[boxName] == null || !_boxes[boxName]!.isOpen) {
      _boxes[boxName] = await Hive.openBox<Map>(boxName);
    }
    return _boxes[boxName]!;
  }

  Future<bool> insert(String boxName, dynamic key, dynamic data) async {
    try {
      final box = await _getBox(boxName);
      Map<String, dynamic> dataMap = data is Map<String, dynamic>
          ? data
          : data.toJson();
      await box.put(key, dataMap);
      return true;
    } catch (e) {
      print('Error inserting data: $e');
      return false;
    }
  }
}
```

### Testing Patterns

#### Unit Test Structure

```dart
import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/movies/get_now_playing_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetNowPlayingMovies usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetNowPlayingMovies(mockMovieRepository);
  });

  final tMovies = <Movie>[];

  test('should get list of movies from the repository', () async {
    // arrange
    when(mockMovieRepository.getNowPlayingMovies())
        .thenAnswer((_) async => Right(tMovies));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tMovies));
  });
}
```

### Error Handling Patterns

#### Failure Classes

```dart
abstract class Failure extends Equatable {
  final String message;

  Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  ServerFailure(String message) : super(message);
}

class ConnectionFailure extends Failure {
  ConnectionFailure(String message) : super(message);
}

class DatabaseFailure extends Failure {
  DatabaseFailure(String message) : super(message);
}
```

#### Exception Classes

```dart
class ServerException implements Exception {
  final dynamic response;

  ServerException([this.response]);
}

class DatabaseException implements Exception {
  final String message;

  DatabaseException(this.message);
}
```

## Development Workflow

### Adding New Features

1. **Create Entity** in `lib/domain/entities/`
2. **Create Model** in `lib/data/models/` with `fromJson`, `toJson`, `toEntity`
3. **Create Repository Interface** in `lib/domain/repositories/`
4. **Create Use Case** in `lib/domain/usecases/`
5. **Create Data Sources** in `lib/data/datasources/`
6. **Create Repository Implementation** in `lib/data/repositories/`
7. **Create Provider** in `lib/presentation/provider/`
8. **Register Dependencies** in `lib/injection.dart`
9. **Create UI** in `lib/presentation/pages/` and `lib/presentation/widgets/`
10. **Create Tests** mirroring the lib structure

### File Naming Conventions

- **Entities**: `movie.dart`, `tv_series.dart`
- **Models**: `movie_model.dart`, `movie_response.dart`
- **Use Cases**: `get_now_playing_movies.dart`
- **Providers**: `movie_list_notifier.dart`
- **Data Sources**: `movie_remote_data_source.dart`
- **Tests**: Mirror lib structure exactly

## Common Gotchas

- Always handle both success and failure cases in Either.fold()
- Use `RequestState` enum for loading/error states in UI
- Register new dependencies in injection.dart immediately
- Test files must mirror lib structure exactly
- Models must have `fromJson`, `toJson`, and `toEntity` methods
- Entities must extend `Equatable` and override `props`
- Use `locator()` for dependency injection in constructors
- Always call `notifyListeners()` after state changes in providers
- Handle `ServerException` and `SocketException` in repository implementations</content>
  <parameter name="filePath">d:\---CODING--\Dicoding2025\Flutter\submission_1_expert\.github\copilot-instructions.md
