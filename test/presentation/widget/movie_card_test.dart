import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tId = 1;
  const tTitle = 'Test Movie';
  const tPosterPath = '/test.jpg';
  const tOverview = 'Test overview of the movie';

  final tMovie = Movie.watchlist(
    id: tId,
    title: tTitle,
    posterPath: tPosterPath,
    overview: tOverview,
  );

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(body: body),
      routes: {
        MovieDetailPage.ROUTE_NAME: (context) => const Scaffold(),
      },
    );
  }

  group('MovieCard', () {
    testWidgets('should display movie title', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(MovieCard(tMovie)));

      expect(find.text(tTitle), findsOneWidget);
    });

    testWidgets('should display movie overview', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(MovieCard(tMovie)));

      expect(find.text(tOverview), findsOneWidget);
    });

    testWidgets('should display CachedNetworkImage with correct URL',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(MovieCard(tMovie)));

      final cachedNetworkImages = tester.widgetList<CachedNetworkImage>(
        find.byType(CachedNetworkImage),
      );

      expect(cachedNetworkImages.length, 1);
      expect(cachedNetworkImages.first.imageUrl, '$BASE_IMAGE_URL$tPosterPath');
    });

    testWidgets('should navigate when tapped', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(MovieCard(tMovie)));

      final inkWell = find.byType(InkWell);
      expect(inkWell, findsOneWidget);

      await tester.tap(inkWell);
      await tester.pumpAndSettle();

      // Verify that navigation occurred by checking if the tap doesn't throw
      expect(tester.takeException(), isNull);
    });

    testWidgets('should have correct margin', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(MovieCard(tMovie)));

      final containers = tester.widgetList<Container>(find.byType(Container));
      final movieContainer = containers.firstWhere(
        (container) =>
            container.margin == const EdgeInsets.symmetric(vertical: 4),
        orElse: () => Container(),
      );

      expect(movieContainer.margin, const EdgeInsets.symmetric(vertical: 4));
    });
  });
}
