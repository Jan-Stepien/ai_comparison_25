import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:cursor/movies/details/data/services/movie_details_remote_service.dart';
import 'package:cursor/movies/details/domain/models/movie_details.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MovieDetailsRemoteService service;
  late MockHttpClient mockHttpClient;

  const apiKey = 'test_api_key';
  const baseUrl = 'api.themoviedb.org';
  const movieId = 123;

  final testMovieDetails = MovieDetails(
    id: movieId,
    title: 'Test Movie',
    budget: 1000000,
    revenue: 2000000,
  );

  setUp(() {
    mockHttpClient = MockHttpClient();
    service = MovieDetailsRemoteService(
      apiKey: apiKey,
      baseUrl: baseUrl,
      client: mockHttpClient,
    );
  });

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  group('fetchMovieDetails', () {
    test('returns MovieDetails when API call is successful', () async {
      final response = http.Response(
        jsonEncode(testMovieDetails.toJson()),
        200,
      );

      when(() => mockHttpClient.get(any())).thenAnswer((_) async => response);

      final result = await service.fetchMovieDetails(movieId);

      expect(result, equals(testMovieDetails));
      verify(
        () => mockHttpClient.get(
          Uri.https(
            baseUrl,
            '/3/movie/$movieId',
            {'api_key': apiKey},
          ),
        ),
      ).called(1);
    });
  });
}
