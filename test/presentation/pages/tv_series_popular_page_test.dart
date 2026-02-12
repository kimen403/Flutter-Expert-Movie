import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/tv_series/popular_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/popular_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPopularTvSeriesCubit extends MockCubit<PopularTvSeriesState>
    implements PopularTvSeriesCubit {}

void main() {
  late MockPopularTvSeriesCubit mockCubit;

  setUp(() {
    mockCubit = MockPopularTvSeriesCubit();
    when(() => mockCubit.fetchPopularTvSeries()).thenAnswer((_) async {});
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularTvSeriesCubit>.value(
      value: mockCubit,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockCubit.state)
        .thenReturn(const PopularTvSeriesState(state: RequestState.Loading));

    await tester.pumpWidget(makeTestableWidget(PopularTvSeriesPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockCubit.state).thenReturn(
        const PopularTvSeriesState(state: RequestState.Loaded, tvSeries: []));

    await tester.pumpWidget(makeTestableWidget(PopularTvSeriesPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockCubit.state).thenReturn(const PopularTvSeriesState(
        state: RequestState.Error, message: 'Error message'));

    await tester.pumpWidget(makeTestableWidget(PopularTvSeriesPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });
}
