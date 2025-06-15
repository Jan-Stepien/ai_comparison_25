import 'package:flutter_test/flutter_test.dart';
import 'package:blackbox/movies/details/domain/models/movie_details.dart';
import 'package:blackbox/movies/details/domain/repositories/movie_details_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/service_mocks.dart';

void main() {
  late MovieDetailsRepository repository;
  late MockMovieDetailsLocalService mockLocalService;
  late MockMovieDetailsRemoteService mockRemoteService;

  final mockMovieDetails = MovieDetails(
    id: 1,
    title: 'Test Movie',
    budget: 1000000,
    revenue: 2000000,
  );

  setUp(() {
    mockLocalService = MockMovieDetailsLocalService();
    mockRemoteService = MockMovieDetailsRemoteService();
    repository = MovieDetailsRepository(
      localService: mockLocalService,
      remoteService: mockRemoteService,
    );
  });

  setUpAll(() {
    registerFallbackValue(mockMovieDetails);
  });

  group('MovieDetailsRepository', () {
    test('fetchMovieDetails should fetch from remote and save to local',
        () async {
      when(() => mockRemoteService.fetchMovieDetails(1))
          .thenAnswer((_) async => mockMovieDetails);
      when(() => mockLocalService.saveMovieDetails(mockMovieDetails))
          .thenAnswer((_) async {});

      await repository.fetchMovieDetails(movieId: 1);

      verify(() => mockRemoteService.fetchMovieDetails(1)).called(1);
      verify(() => mockLocalService.saveMovieDetails(mockMovieDetails))
          .called(1);
    });

    test('stream should return local service stream', () {
      when(() => mockLocalService.stream).thenAnswer((_) =>
          Stream.fromIterable([mockMovieDetails, null, mockMovieDetails]));

      expect(
        repository.stream,
        emitsInOrder([mockMovieDetails, null, mockMovieDetails]),
      );
    });
  });
}
