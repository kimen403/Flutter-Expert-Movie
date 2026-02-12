import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/models/movie_table.dart';

abstract class MovieLocalDataSource {
  Future<String> insertWatchlist(MovieTable movie);
  Future<String> removeWatchlist(MovieTable movie);
  Future<MovieTable?> getMovieById(int id);
  Future<List<MovieTable>> getWatchlistMovies();
  Future<bool> isInWatchlist(int id);
  Future<int> getWatchlistCount();
  Future<String> clearWatchlist();
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final DatabaseHelper databaseHelper;
  static const String _boxName = 'watchlist_movies';

  MovieLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertWatchlist(MovieTable movie) async {
    print('Inserting movie with id: ${movie.id}');
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

  @override
  Future<String> removeWatchlist(MovieTable movie) async {
    try {
      final success = await databaseHelper.delete(_boxName, movie.id);
      if (success) {
        return 'Removed from Watchlist';
      } else {
        throw DatabaseException('Movie not found in watchlist');
      }
    } catch (e) {
      throw DatabaseException('Error removing from watchlist: ${e.toString()}');
    }
  }

  @override
  Future<MovieTable?> getMovieById(int id) async {
    try {
      final result = await databaseHelper.getByKey(_boxName, id);
      if (result != null) {
        return MovieTable.fromMap(result);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      throw DatabaseException('Error getting movie by id: ${e.toString()}');
    }
  }

  @override
  Future<List<MovieTable>> getWatchlistMovies() async {
    try {
      final result = await databaseHelper.getAll(_boxName);
      return result.map((data) => MovieTable.fromMap(data)).toList();
    } catch (e) {
      throw DatabaseException(
          'Error getting watchlist movies: ${e.toString()}');
    }
  }

  @override
  Future<bool> isInWatchlist(int id) async {
    try {
      return await databaseHelper.containsKey(_boxName, id);
    } catch (e) {
      throw DatabaseException(
          'Error checking watchlist status: ${e.toString()}');
    }
  }

  @override
  Future<int> getWatchlistCount() async {
    try {
      return await databaseHelper.count(_boxName);
    } catch (e) {
      throw DatabaseException('Error getting watchlist count: ${e.toString()}');
    }
  }

  @override
  Future<String> clearWatchlist() async {
    try {
      final success = await databaseHelper.clear(_boxName);
      if (success) {
        return 'Watchlist cleared successfully';
      } else {
        throw DatabaseException('Failed to clear watchlist');
      }
    } catch (e) {
      throw DatabaseException('Error clearing watchlist: ${e.toString()}');
    }
  }
}
