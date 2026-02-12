import 'dart:convert';

import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:equatable/equatable.dart';

class TvSeriesModel extends Equatable {
  final bool adult;
  final String? backdropPath;
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

  TvSeriesModel({
    required this.adult,
    this.backdropPath,
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

  factory TvSeriesModel.fromRawJson(String str) =>
      TvSeriesModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TvSeriesModel.fromJson(Map<String, dynamic> json) => TvSeriesModel(
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        id: json["id"],
        originCountry: List<String>.from(json["origin_country"].map((x) => x)),
        originalLanguage: json["original_language"],
        originalName: json["original_name"],
        overview: json["overview"],
        popularity: json["popularity"]?.toDouble(),
        posterPath: json["poster_path"],
        firstAirDate: json["first_air_date"],
        name: json["name"],
        voteAverage: json["vote_average"]?.toDouble(),
        voteCount: json["vote_count"],
      );

  factory TvSeriesModel.fromMap(Map<String, dynamic> map) => TvSeriesModel(
        adult: map["adult"],
        backdropPath: map["backdropPath"],
        genreIds: List<int>.from(map["genreIds"].map((x) => x)),
        id: map["id"],
        originCountry: List<String>.from(map["originCountry"].map((x) => x)),
        originalLanguage: map["originalLanguage"],
        originalName: map["originalName"],
        overview: map["overview"],
        popularity: map["popularity"]?.toDouble(),
        posterPath: map["posterPath"],
        firstAirDate: map["firstAirDate"],
        name: map["name"],
        voteAverage: map["voteAverage"]?.toDouble(),
        voteCount: map["voteCount"],
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "id": id,
        "origin_country": List<dynamic>.from(originCountry.map((x) => x)),
        "original_language": originalLanguage,
        "original_name": originalName,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "first_air_date": firstAirDate,
        "name": name,
        "vote_average": voteAverage,
        "vote_count": voteCount,
      };

  @override
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

  TvSeries toEntity() {
    return TvSeries(
      adult: this.adult,
      backdropPath: this.backdropPath ?? '',
      genreIds: this.genreIds,
      id: this.id,
      originCountry: this.originCountry,
      originalLanguage: this.originalLanguage,
      originalName: this.originalName,
      overview: this.overview,
      popularity: this.popularity,
      posterPath: this.posterPath ?? '',
      firstAirDate: this.firstAirDate ?? '',
      name: this.name,
      voteAverage: this.voteAverage,
      voteCount: this.voteCount,
    );
  }
}
