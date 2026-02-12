import 'package:equatable/equatable.dart';

class TvSeries extends Equatable {
  final bool adult;
  final String backdropPath;
  final List<int> genreIds;
  final int id;
  final List<String> originCountry;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final double popularity;
  final String? posterPath;
  final String? firstAirDate;
  final String name;
  final double voteAverage;
  final int voteCount;

  TvSeries({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.firstAirDate,
    required this.name,
    required this.voteAverage,
    required this.voteCount,
  });

  TvSeries.watchlist({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.overview,
  })  : adult = false,
        backdropPath = '',
        genreIds = const [],
        originCountry = const [],
        originalLanguage = '',
        originalName = '',
        popularity = 0.0,
        firstAirDate = null,
        voteAverage = 0.0,
        voteCount = 0;

  @override
  // TODO: implement props
  List<Object?> get props => [
        adult,
        backdropPath,
        genreIds,
        id,
        originCountry,
        originalLanguage,
        originalName,
        overview,
        popularity,
        posterPath,
        firstAirDate,
        name,
        voteAverage,
        voteCount,
      ];
}
