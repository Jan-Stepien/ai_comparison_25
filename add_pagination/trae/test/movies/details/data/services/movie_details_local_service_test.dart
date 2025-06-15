import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:trae/movies/details/data/services/movie_details_local_service.dart';
import 'package:trae/movies/details/domain/models/movie_details.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/third_party_mocks.dart';

void main() {
  late MovieDetailsLocalService service;
  late MockSharedPreferences mockStorage;

  final testMovieDetails = MovieDetails(
    id: 1,
    title: 'Test Movie',
    budget: 1000000,
    revenue: 2000000,
  );

  setUp(() {
    mockStorage = MockSharedPreferences();
    service = MovieDetailsLocalService(storage: mockStorage);
  });

  group('saveMovieDetails', () {
    test('saves movie details to storage and emits to stream', () async {
      when(() => mockStorage.setString(any(), any()))
          .thenAnswer((_) async => true);

      await service.saveMovieDetails(testMovieDetails);

      verify(() => mockStorage.setString(
            'k_movie_details',
            any(),
          )).called(1);

      expect(service.stream, emits(testMovieDetails));
    });
  });

  group('clear', () {
    test('removes movie details from storage and emits null to stream',
        () async {
      when(() => mockStorage.remove(any())).thenAnswer((_) async => true);

      await service.clear();

      verify(() => mockStorage.remove('k_movie_details')).called(1);
      expect(service.stream, emits(null));
    });
  });

  group('initialization', () {
    test('returns null and emits null when local storage is broken', () {
      when(() => mockStorage.getString(any())).thenReturn('{');
      when(() => mockStorage.remove(any())).thenAnswer((_) async => true);

      expect(service.stream, emits(null));
    });

    test('returns movie details and emits them when local storage is valid',
        () {
      when(() => mockStorage.getString(any()))
          .thenReturn(jsonEncode(testMovieDetails.toJson()));

      expect(service.stream, emits(testMovieDetails));
    });
  });
}
