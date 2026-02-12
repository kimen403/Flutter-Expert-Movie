import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movies/movie_detail_bloc.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockMovieDetailCubit extends MockCubit<MovieDetailState>
    implements MovieDetailCubit {}

void main() {
  late MockMovieDetailCubit mockCubit;

  setUp(() {
    mockCubit = MockMovieDetailCubit();
    when(() => mockCubit.fetchMovieDetail(any())).thenAnswer((_) async {});
    when(() => mockCubit.loadWatchlistStatus(any())).thenAnswer((_) async {});
  });

  setUpAll(() {
    registerFallbackValue(testMovieDetail);
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailCubit>.value(
      value: mockCubit,
      child: MaterialApp(home: body),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(() => mockCubit.state).thenReturn(MovieDetailState(
      movieState: RequestState.Loaded,
      movie: testMovieDetail,
      recommendationState: RequestState.Loaded,
      movieRecommendations: <Movie>[],
      isAddedToWatchlist: false,
    ));

    final watchlistButtonIcon = find.byIcon(Icons.add);
    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when movie is added to watchlist',
      (WidgetTester tester) async {
    when(() => mockCubit.state).thenReturn(MovieDetailState(
      movieState: RequestState.Loaded,
      movie: testMovieDetail,
      recommendationState: RequestState.Loaded,
      movieRecommendations: <Movie>[],
      isAddedToWatchlist: true,
    ));

    final watchlistButtonIcon = find.byIcon(Icons.check);
    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    whenListen(
      mockCubit,
      Stream.fromIterable([
        MovieDetailState(
          movieState: RequestState.Loaded,
          movie: testMovieDetail,
          recommendationState: RequestState.Loaded,
          movieRecommendations: <Movie>[],
          isAddedToWatchlist: false,
        ),
        MovieDetailState(
          movieState: RequestState.Loaded,
          movie: testMovieDetail,
          recommendationState: RequestState.Loaded,
          movieRecommendations: <Movie>[],
          isAddedToWatchlist: true,
          watchlistMessage: 'Added to Watchlist',
        ),
      ]),
      initialState: MovieDetailState(
        movieState: RequestState.Loaded,
        movie: testMovieDetail,
        recommendationState: RequestState.Loaded,
        movieRecommendations: <Movie>[],
        isAddedToWatchlist: false,
      ),
    );
    when(() => mockCubit.addWatchlist(any())).thenAnswer((_) async {});

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

    final watchlistButton = find.byType(FilledButton);
    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    whenListen(
      mockCubit,
      Stream.fromIterable([
        MovieDetailState(
          movieState: RequestState.Loaded,
          movie: testMovieDetail,
          recommendationState: RequestState.Loaded,
          movieRecommendations: <Movie>[],
          isAddedToWatchlist: false,
        ),
        MovieDetailState(
          movieState: RequestState.Loaded,
          movie: testMovieDetail,
          recommendationState: RequestState.Loaded,
          movieRecommendations: <Movie>[],
          isAddedToWatchlist: false,
          watchlistMessage: 'Failed',
        ),
      ]),
      initialState: MovieDetailState(
        movieState: RequestState.Loaded,
        movie: testMovieDetail,
        recommendationState: RequestState.Loaded,
        movieRecommendations: <Movie>[],
        isAddedToWatchlist: false,
      ),
    );
    when(() => mockCubit.addWatchlist(any())).thenAnswer((_) async {});

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

    final watchlistButton = find.byType(FilledButton);
    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
