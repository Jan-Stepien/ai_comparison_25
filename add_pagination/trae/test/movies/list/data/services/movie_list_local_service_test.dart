import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:trae/movies/list/data/services/movie_list_local_service.dart';
import 'package:trae/movies/list/domain/models/movie_list_item.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MovieListLocalService service;
  late MockSharedPreferences mockStorage;

  final testMovies = [
    MovieListItem(id: 1, title: 'Test Movie 1', voteAverage: 8.5),
    MovieListItem(id: 2, title: 'Test Movie 2', voteAverage: 9.0),
  ];

  setUp(() {
    mockStorage = MockSharedPreferences();
    service = MovieListLocalService(storage: mockStorage);
  });

  group('MovieListLocalService', () {
    group('saveSearchResults', () {
      test(
          'replaces movies to storage and emits to stream when shouldReplace is true',
          () async {
        when(() => mockStorage.remove(any())).thenAnswer((_) async => true);
        when(() => mockStorage.setString(any(), any()))
            .thenAnswer((_) async => true);

        await service.saveSearchResults(
          results: testMovies,
          shouldReplace: true,
        );

        verify(() => mockStorage.remove('k_movie_search_history')).called(1);
        verify(() => mockStorage.setString(
              'k_movie_search_history',
              any(),
            )).called(1);

        expect(service.stream, emits(testMovies));
      });

      test(
          'saves movies to storage and emits to stream when shouldReplace is false',
          () async {
        when(() => mockStorage.setString(any(), any()))
            .thenAnswer((_) async => true);

        await service.saveSearchResults(
          results: testMovies,
          shouldReplace: false,
        );

        verifyNever(() => mockStorage.remove(any()));
        verify(() => mockStorage.setString(
              'k_movie_search_history',
              any(),
            )).called(1);

        expect(service.stream, emits(testMovies));
      });
    });

    group('clear', () {
      test('removes movies from storage and emits empty list to stream',
          () async {
        when(() => mockStorage.remove(any())).thenAnswer((_) async => true);

        await service.clear();

        verify(() => mockStorage.remove('k_movie_search_history')).called(1);
        expect(service.stream, emits(<MovieListItem>[]));
      });
    });

    group('initialization', () {
      test('returns empty list and emits empty list when storage is empty', () {
        when(() => mockStorage.getString(any())).thenReturn(null);

        expect(service.stream, emits(<MovieListItem>[]));
      });

      test('returns movies and emits them when storage has valid data', () {
        when(() => mockStorage.getString(any()))
            .thenReturn(jsonEncode(testMovies.map((m) => m.toJson()).toList()));

        expect(service.stream, emits(testMovies));
      });

      test(
          'returns empty list and emits empty list when storage has invalid data',
          () {
        when(() => mockStorage.getString(any())).thenReturn('{');
        when(() => mockStorage.remove(any())).thenAnswer((_) async => true);

        expect(service.stream, emits(<MovieListItem>[]));
      });
    });
  });
}
