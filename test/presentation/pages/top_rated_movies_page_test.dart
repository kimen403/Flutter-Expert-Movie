import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/movies/top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTopRatedMoviesCubit extends MockCubit<TopRatedMoviesState>
    implements TopRatedMoviesCubit {}

void main() {
  late MockTopRatedMoviesCubit mockCubit;

  setUp(() {
    mockCubit = MockTopRatedMoviesCubit();
    when(() => mockCubit.fetchTopRatedMovies()).thenAnswer((_) async {});
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedMoviesCubit>.value(
      value: mockCubit,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockCubit.state)
        .thenReturn(const TopRatedMoviesState(state: RequestState.Loading));

    await tester.pumpWidget(makeTestableWidget(TopRatedMoviesPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    when(() => mockCubit.state).thenReturn(
        const TopRatedMoviesState(state: RequestState.Loaded, movies: []));

    await tester.pumpWidget(makeTestableWidget(TopRatedMoviesPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockCubit.state).thenReturn(const TopRatedMoviesState(
        state: RequestState.Error, message: 'Error message'));

    await tester.pumpWidget(makeTestableWidget(TopRatedMoviesPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });
}
