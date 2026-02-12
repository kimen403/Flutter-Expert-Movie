import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/db/database_helper.dart';

import 'package:ditonton/data/models/tv_series_table.dart';

abstract class TvSeriesLocalDataSource {
  Future<String> insertWatchlist(TvSeriesTable tvSeries);
  Future<List<TvSeriesTable>> getTvSeriesWatchList();
  Future<String> deleteTvSeriesWatchList(int id);
  Future<bool> isInWatchlist(int id);
  Future<int> getWatchlistCount();
  Future<String> clearWatchlist();
}

class TvSeriesLocalDataSourceImpl implements TvSeriesLocalDataSource {
  final DatabaseHelper databaseHelper;

  static const String _boxName = 'watchlist_tv_series';

  TvSeriesLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertWatchlist(TvSeriesTable tvSeries) async {
    try {
      await databaseHelper.insert(_boxName, tvSeries.id, tvSeries);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<List<TvSeriesTable>> getTvSeriesWatchList() async {
    try {
      final result = await databaseHelper.getAll(_boxName);
      return result.map((data) => TvSeriesTable.fromMap(data)).toList();
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> deleteTvSeriesWatchList(int id) async {
    try {
      await databaseHelper.delete(_boxName, id);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<bool> isInWatchlist(int id) async {
    try {
      return await databaseHelper.containsKey(_boxName, id);
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<int> getWatchlistCount() async {
    try {
      return await databaseHelper.count(_boxName);
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> clearWatchlist() async {
    try {
      await databaseHelper.clear(_boxName);
      return 'Watchlist cleared';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}
