import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/data/models/tv_series_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);
final testTvSeriesTable = TvSeriesTable(
  id: 1,
  name: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};
final testTvSeriesMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'name': 'title',
};

final testTvSeries = TvSeries(
  adult: false,
  backdropPath: '/qg8Gv2w0dDL8cMsG2QO2hWp58wy.jpg',
  genreIds: [10765, 9648, 35],
  id: 119051,
  originCountry: ['US'],
  originalLanguage: 'en',
  originalName: 'Wednesday',
  overview:
      'Smart, sarcastic and a little dead inside, Wednesday Addams investigates twisted mysteries while making new friends — and foes — at Nevermore Academy.',
  popularity: 391.7456,
  posterPath: '/36xXlhEpQqVVPuiZhfoQuaY4OlA.jpg',
  firstAirDate: '2022-11-23',
  name: 'Wednesday',
  voteAverage: 8.4,
  voteCount: 9486,
);

final testTvSeriesList = [testTvSeries];

final testTvSeriesDetail = TvSeriesDetail(
  adult: false,
  backdropPath: '/qg8Gv2w0dDL8cMsG2QO2hWp58wy.jpg',
  episodeRunTime: [45],
  firstAirDate: '2022-11-23',
  genres: [
    Genre(id: 10765, name: 'Sci-Fi & Fantasy'),
    Genre(id: 9648, name: 'Mystery'),
    Genre(id: 35, name: 'Comedy'),
  ],
  homepage: 'https://www.netflix.com/title/81231974',
  id: 119051,
  inProduction: false,
  languages: ['en'],
  lastAirDate: '2022-11-23',
  name: 'Wednesday',
  nextEpisodeToAir: null,
  numberOfEpisodes: 8,
  numberOfSeasons: 1,
  originCountry: ['US'],
  originalLanguage: 'en',
  originalName: 'Wednesday',
  overview:
      'Smart, sarcastic and a little dead inside, Wednesday Addams investigates twisted mysteries while making new friends — and foes — at Nevermore Academy.',
  popularity: 344.95,
  posterPath: '/36xXlhEpQqVVPuiZhfoQuaY4OlA.jpg',
  status: 'Ended',
  tagline: 'Smart, sarcastic and a little dead inside.',
  type: 'Miniseries',
  voteAverage: 8.401,
  voteCount: 9511,
);

final testWatchlistTvSeries = TvSeries.watchlist(
  id: 1,
  name: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);
