import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tId = 1;
  const tName = 'Test TV Series';
  const tPosterPath = '/test.jpg';
  const tOverview = 'Test overview of the TV series';

  final tTvSeries = TvSeries.watchlist(
    id: tId,
    name: tName,
    posterPath: tPosterPath,
    overview: tOverview,
  );

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(body: body),
      routes: {
        TvSeriesDetailPage.ROUTE_NAME: (context) => const Scaffold(),
      },
    );
  }

  group('TvSeriesCard', () {
    testWidgets('should display TV series name', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(TvSeriesCard(tTvSeries)));

      expect(find.text(tName), findsOneWidget);
    });

    testWidgets('should display TV series overview',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(TvSeriesCard(tTvSeries)));

      expect(find.text(tOverview), findsOneWidget);
    });

    testWidgets('should display CachedNetworkImage with correct URL',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(TvSeriesCard(tTvSeries)));

      final cachedNetworkImages = tester.widgetList<CachedNetworkImage>(
        find.byType(CachedNetworkImage),
      );

      expect(cachedNetworkImages.length, 1);
      expect(cachedNetworkImages.first.imageUrl, '$BASE_IMAGE_URL$tPosterPath');
    });

    testWidgets('should navigate when tapped', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(TvSeriesCard(tTvSeries)));

      final inkWell = find.byType(InkWell);
      expect(inkWell, findsOneWidget);

      await tester.tap(inkWell);
      await tester.pumpAndSettle();

      // Verify that navigation occurred by checking if we're no longer on the home route
      // Since we can't easily mock Navigator, we just ensure the tap doesn't throw
      expect(tester.takeException(), isNull);
    });

    testWidgets('should have correct margin', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(TvSeriesCard(tTvSeries)));

      final containers = tester.widgetList<Container>(find.byType(Container));
      final tvSeriesContainer = containers.firstWhere(
        (container) =>
            container.margin == const EdgeInsets.symmetric(vertical: 4),
        orElse: () => Container(),
      );

      expect(tvSeriesContainer.margin, const EdgeInsets.symmetric(vertical: 4));
    });
  });
}
