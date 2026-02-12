import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:equatable/equatable.dart';

class TvSeriesTable extends Equatable {
  final int id;
  final String name;
  final String? posterPath;
  final String overview;

  TvSeriesTable({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.overview,
  });

  factory TvSeriesTable.fromMap(Map<String, dynamic> map) {
    return TvSeriesTable(
      id: map['id'],
      name: map['name'],
      posterPath: map['posterPath'],
      overview: map['overview'],
    );
  }

  factory TvSeriesTable.fromEntity(TvSeries tvSeries) {
    return TvSeriesTable(
      id: tvSeries.id,
      name: tvSeries.name,
      posterPath: tvSeries.posterPath,
      overview: tvSeries.overview,
    );
  }

  factory TvSeriesTable.fromJson(Map<String, dynamic> json) {
    return TvSeriesTable(
      id: json['id'],
      name: json['name'],
      posterPath: json['posterPath'],
      overview: json['overview'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'posterPath': posterPath,
      'overview': overview,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'posterPath': posterPath,
      'overview': overview,
    };
  }

  TvSeries toEntity() {
    return TvSeries.watchlist(
      id: id,
      name: name,
      posterPath: posterPath,
      overview: overview,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        posterPath,
        overview,
      ];
}
