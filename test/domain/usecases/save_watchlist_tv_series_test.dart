import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tv_series/save_watchlist_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SaveWatchlistTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = SaveWatchlistTvSeries(mockTvSeriesRepository);
  });

  test('should save watchlist tv series to repository', () async {
    // arrange
    when(mockTvSeriesRepository.saveWatchlist(testTvSeriesDetail))
        .thenAnswer((_) async => Right('Added to watchlist'));
    // act
    final result = await usecase.execute(testTvSeriesDetail);
    // assert
    expect(result, Right('Added to watchlist'));
  });
}
