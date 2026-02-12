import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/tv_series/top_rated_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTopRatedTvSeriesCubit extends MockCubit<TopRatedTvSeriesState>
    implements TopRatedTvSeriesCubit {}

void main() {
  late MockTopRatedTvSeriesCubit mockCubit;

  setUp(() {
    mockCubit = MockTopRatedTvSeriesCubit();
    when(() => mockCubit.fetchTopRatedTvSeries()).thenAnswer((_) async {});
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTvSeriesCubit>.value(
      value: mockCubit,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockCubit.state)
        .thenReturn(const TopRatedTvSeriesState(state: RequestState.Loading));

    await tester.pumpWidget(makeTestableWidget(TopRatedTvSeriesPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    when(() => mockCubit.state).thenReturn(
        const TopRatedTvSeriesState(state: RequestState.Loaded, tvSeries: []));

    await tester.pumpWidget(makeTestableWidget(TopRatedTvSeriesPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockCubit.state).thenReturn(const TopRatedTvSeriesState(
        state: RequestState.Error, message: 'Error message'));

    await tester.pumpWidget(makeTestableWidget(TopRatedTvSeriesPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });
}
