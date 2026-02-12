import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvSeriesRecommendations usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetTvSeriesRecommendations(mockTvSeriesRepository);
  });

  final tId = 1;

  test('should get tv series recommendations from the repository', () async {
    // arrange
    when(mockTvSeriesRepository.getTvSeriesRecommendations(any))
        .thenAnswer((_) async => Right(testTvSeriesList));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, Right(testTvSeriesList));
  });
}
