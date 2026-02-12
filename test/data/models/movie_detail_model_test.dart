import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/movie_detail_model.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tAdult = false;
  const tBackdropPath = '/backdrop.jpg';
  const tBudget = 1000000;
  const tHomepage = 'https://example.com';
  const tId = 1;
  const tImdbId = 'tt1234567';
  const tOriginalLanguage = 'en';
  const tOriginalTitle = 'Original Title';
  const tOverview = 'Overview';
  const tPopularity = 8.5;
  const tPosterPath = '/poster.jpg';
  const tReleaseDate = '2023-01-01';
  const tRevenue = 5000000;
  const tRuntime = 120;
  const tStatus = 'Released';
  const tTagline = 'Tagline';
  const tTitle = 'Title';
  const tVideo = false;
  const tVoteAverage = 7.5;
  const tVoteCount = 1000;

  final tGenres = [
    GenreModel(id: 1, name: 'Action'),
    GenreModel(id: 2, name: 'Drama'),
  ];

  final tGenresEntity = [
    Genre(id: 1, name: 'Action'),
    Genre(id: 2, name: 'Drama'),
  ];

  final tMovieDetailResponse = MovieDetailResponse(
    adult: tAdult,
    backdropPath: tBackdropPath,
    budget: tBudget,
    genres: tGenres,
    homepage: tHomepage,
    id: tId,
    imdbId: tImdbId,
    originalLanguage: tOriginalLanguage,
    originalTitle: tOriginalTitle,
    overview: tOverview,
    popularity: tPopularity,
    posterPath: tPosterPath,
    releaseDate: tReleaseDate,
    revenue: tRevenue,
    runtime: tRuntime,
    status: tStatus,
    tagline: tTagline,
    title: tTitle,
    video: tVideo,
    voteAverage: tVoteAverage,
    voteCount: tVoteCount,
  );

  final tMovieDetail = MovieDetail(
    adult: tAdult,
    backdropPath: tBackdropPath,
    genres: tGenresEntity,
    id: tId,
    originalTitle: tOriginalTitle,
    overview: tOverview,
    posterPath: tPosterPath,
    releaseDate: tReleaseDate,
    runtime: tRuntime,
    title: tTitle,
    voteAverage: tVoteAverage,
    voteCount: tVoteCount,
  );

  group('MovieDetailResponse', () {
    test('should create MovieDetailResponse from JSON correctly', () {
      final json = {
        'adult': tAdult,
        'backdrop_path': tBackdropPath,
        'budget': tBudget,
        'genres': [
          {'id': 1, 'name': 'Action'},
          {'id': 2, 'name': 'Drama'},
        ],
        'homepage': tHomepage,
        'id': tId,
        'imdb_id': tImdbId,
        'original_language': tOriginalLanguage,
        'original_title': tOriginalTitle,
        'overview': tOverview,
        'popularity': tPopularity,
        'poster_path': tPosterPath,
        'release_date': tReleaseDate,
        'revenue': tRevenue,
        'runtime': tRuntime,
        'status': tStatus,
        'tagline': tTagline,
        'title': tTitle,
        'video': tVideo,
        'vote_average': tVoteAverage,
        'vote_count': tVoteCount,
      };

      final result = MovieDetailResponse.fromJson(json);

      expect(result, tMovieDetailResponse);
    });

    test('should convert to JSON correctly', () {
      final expectedJson = {
        'adult': tAdult,
        'backdrop_path': tBackdropPath,
        'budget': tBudget,
        'genres': [
          {'id': 1, 'name': 'Action'},
          {'id': 2, 'name': 'Drama'},
        ],
        'homepage': tHomepage,
        'id': tId,
        'imdb_id': tImdbId,
        'original_language': tOriginalLanguage,
        'original_title': tOriginalTitle,
        'overview': tOverview,
        'popularity': tPopularity,
        'poster_path': tPosterPath,
        'release_date': tReleaseDate,
        'revenue': tRevenue,
        'runtime': tRuntime,
        'status': tStatus,
        'tagline': tTagline,
        'title': tTitle,
        'video': tVideo,
        'vote_average': tVoteAverage,
        'vote_count': tVoteCount,
      };

      final result = tMovieDetailResponse.toJson();

      expect(result, expectedJson);
    });

    test('should convert to Entity correctly', () {
      final result = tMovieDetailResponse.toEntity();

      expect(result, tMovieDetail);
    });

    test('should have correct props', () {
      expect(tMovieDetailResponse.props, [
        tAdult,
        tBackdropPath,
        tBudget,
        tGenres,
        tHomepage,
        tId,
        tImdbId,
        tOriginalLanguage,
        tOriginalTitle,
        tOverview,
        tPopularity,
        tPosterPath,
        tReleaseDate,
        tRevenue,
        tRuntime,
        tStatus,
        tTagline,
        tTitle,
        tVideo,
        tVoteAverage,
        tVoteCount,
      ]);
    });

    test('should be equal when all properties are the same', () {
      final other = MovieDetailResponse(
        adult: tAdult,
        backdropPath: tBackdropPath,
        budget: tBudget,
        genres: tGenres,
        homepage: tHomepage,
        id: tId,
        imdbId: tImdbId,
        originalLanguage: tOriginalLanguage,
        originalTitle: tOriginalTitle,
        overview: tOverview,
        popularity: tPopularity,
        posterPath: tPosterPath,
        releaseDate: tReleaseDate,
        revenue: tRevenue,
        runtime: tRuntime,
        status: tStatus,
        tagline: tTagline,
        title: tTitle,
        video: tVideo,
        voteAverage: tVoteAverage,
        voteCount: tVoteCount,
      );

      expect(tMovieDetailResponse, other);
    });

    test('should not be equal when id is different', () {
      final other = MovieDetailResponse(
        adult: tAdult,
        backdropPath: tBackdropPath,
        budget: tBudget,
        genres: tGenres,
        homepage: tHomepage,
        id: 2,
        imdbId: tImdbId,
        originalLanguage: tOriginalLanguage,
        originalTitle: tOriginalTitle,
        overview: tOverview,
        popularity: tPopularity,
        posterPath: tPosterPath,
        releaseDate: tReleaseDate,
        revenue: tRevenue,
        runtime: tRuntime,
        status: tStatus,
        tagline: tTagline,
        title: tTitle,
        video: tVideo,
        voteAverage: tVoteAverage,
        voteCount: tVoteCount,
      );

      expect(tMovieDetailResponse, isNot(other));
    });
  });
}
