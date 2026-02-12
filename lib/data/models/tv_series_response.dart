import 'dart:convert';
import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:equatable/equatable.dart';

class TvSeriesResponse extends Equatable {
  final int page;
  final List<TvSeriesModel> tvSeriesList;
  final int totalPages;
  final int totalResults;

  TvSeriesResponse({
    required this.page,
    required this.tvSeriesList,
    required this.totalPages,
    required this.totalResults,
  });

  factory TvSeriesResponse.fromRawJson(String str) =>
      TvSeriesResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TvSeriesResponse.fromJson(Map<String, dynamic> json) =>
      TvSeriesResponse(
        page: json["page"],
        tvSeriesList: List<TvSeriesModel>.from(
            json["results"].map((x) => TvSeriesModel.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "results": List<dynamic>.from(tvSeriesList.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
      };

  @override
  List<Object?> get props => [
        page,
        tvSeriesList,
        totalPages,
        totalResults,
      ];
}
