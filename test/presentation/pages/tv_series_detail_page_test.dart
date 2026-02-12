import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_detail_bloc.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTvSeriesDetailCubit extends MockCubit<TvSeriesDetailState>
    implements TvSeriesDetailCubit {}

void main() {
  late MockTvSeriesDetailCubit mockCubit;

  setUp(() {
    mockCubit = MockTvSeriesDetailCubit();
    when(() => mockCubit.fetchTvSeriesDetail(any())).thenAnswer((_) async {});
    when(() => mockCubit.loadWatchlistStatus(any())).thenAnswer((_) async {});
  });

  setUpAll(() {
    registerFallbackValue(testTvSeriesDetail);
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TvSeriesDetailCubit>.value(
      value: mockCubit,
      child: MaterialApp(home: body),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when tv series not added to watchlist',
      (WidgetTester tester) async {
    when(() => mockCubit.state).thenReturn(TvSeriesDetailState(
      tvSeriesState: RequestState.Loaded,
      tvSeries: testTvSeriesDetail,
      recommendationState: RequestState.Loaded,
      tvSeriesRecommendations: <TvSeries>[],
      isAddedToWatchlist: false,
    ));

    final watchlistButtonIcon = find.byIcon(Icons.add);
    await tester.pumpWidget(makeTestableWidget(TvSeriesDetailPage(id: 119051)));
    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when tv series is added to watchlist',
      (WidgetTester tester) async {
    when(() => mockCubit.state).thenReturn(TvSeriesDetailState(
      tvSeriesState: RequestState.Loaded,
      tvSeries: testTvSeriesDetail,
      recommendationState: RequestState.Loaded,
      tvSeriesRecommendations: <TvSeries>[],
      isAddedToWatchlist: true,
    ));

    final watchlistButtonIcon = find.byIcon(Icons.check);
    await tester.pumpWidget(makeTestableWidget(TvSeriesDetailPage(id: 119051)));
    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    whenListen(
      mockCubit,
      Stream.fromIterable([
        TvSeriesDetailState(
          tvSeriesState: RequestState.Loaded,
          tvSeries: testTvSeriesDetail,
          recommendationState: RequestState.Loaded,
          tvSeriesRecommendations: <TvSeries>[],
          isAddedToWatchlist: false,
        ),
        TvSeriesDetailState(
          tvSeriesState: RequestState.Loaded,
          tvSeries: testTvSeriesDetail,
          recommendationState: RequestState.Loaded,
          tvSeriesRecommendations: <TvSeries>[],
          isAddedToWatchlist: true,
          watchlistMessage: 'Added to Watchlist',
        ),
      ]),
      initialState: TvSeriesDetailState(
        tvSeriesState: RequestState.Loaded,
        tvSeries: testTvSeriesDetail,
        recommendationState: RequestState.Loaded,
        tvSeriesRecommendations: <TvSeries>[],
        isAddedToWatchlist: false,
      ),
    );
    when(() => mockCubit.addWatchlist(any())).thenAnswer((_) async {});

    await tester.pumpWidget(makeTestableWidget(TvSeriesDetailPage(id: 119051)));

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
        TvSeriesDetailState(
          tvSeriesState: RequestState.Loaded,
          tvSeries: testTvSeriesDetail,
          recommendationState: RequestState.Loaded,
          tvSeriesRecommendations: <TvSeries>[],
          isAddedToWatchlist: false,
        ),
        TvSeriesDetailState(
          tvSeriesState: RequestState.Loaded,
          tvSeries: testTvSeriesDetail,
          recommendationState: RequestState.Loaded,
          tvSeriesRecommendations: <TvSeries>[],
          isAddedToWatchlist: false,
          watchlistMessage: 'Failed',
        ),
      ]),
      initialState: TvSeriesDetailState(
        tvSeriesState: RequestState.Loaded,
        tvSeries: testTvSeriesDetail,
        recommendationState: RequestState.Loaded,
        tvSeriesRecommendations: <TvSeries>[],
        isAddedToWatchlist: false,
      ),
    );
    when(() => mockCubit.addWatchlist(any())).thenAnswer((_) async {});

    await tester.pumpWidget(makeTestableWidget(TvSeriesDetailPage(id: 119051)));

    final watchlistButton = find.byType(FilledButton);
    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
