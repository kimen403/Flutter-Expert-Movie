import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/movies/popular_movies_bloc.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPopularMoviesCubit extends MockCubit<PopularMoviesState>
    implements PopularMoviesCubit {}

void main() {
  late MockPopularMoviesCubit mockCubit;

  setUp(() {
    mockCubit = MockPopularMoviesCubit();
    when(() => mockCubit.fetchPopularMovies()).thenAnswer((_) async {});
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularMoviesCubit>.value(
      value: mockCubit,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockCubit.state)
        .thenReturn(const PopularMoviesState(state: RequestState.Loading));

    await tester.pumpWidget(makeTestableWidget(PopularMoviesPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockCubit.state).thenReturn(
        const PopularMoviesState(state: RequestState.Loaded, movies: []));

    await tester.pumpWidget(makeTestableWidget(PopularMoviesPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockCubit.state).thenReturn(const PopularMoviesState(
        state: RequestState.Error, message: 'Error message'));

    await tester.pumpWidget(makeTestableWidget(PopularMoviesPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });
}
