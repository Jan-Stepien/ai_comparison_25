import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blackbox/movies/details/data/services/movie_details_local_service.dart';
import 'package:blackbox/movies/details/data/services/movie_details_remote_service.dart';
import 'package:blackbox/movies/list/data/services/movie_list_local_service.dart';
import 'package:blackbox/movies/list/data/services/movie_list_remote_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AppServiceProvider extends StatelessWidget {
  const AppServiceProvider({
    super.key,
    required this.child,
    required this.sharedPreferences,
  });

  final Widget child;
  final SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    const movieDbUrl = String.fromEnvironment('MOVIE_DB_URL');
    const movieDbApiKey = String.fromEnvironment('MOVIE_DB_API_KEY');

    final httpClient = http.Client();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create:
              (context) => MovieListLocalService(storage: sharedPreferences),
        ),
        RepositoryProvider(
          create:
              (context) => MovieListRemoteService(
                apiKey: movieDbApiKey,
                baseUrl: movieDbUrl,
                client: httpClient,
              ),
        ),
        RepositoryProvider(
          create:
              (context) => MovieDetailsLocalService(storage: sharedPreferences),
        ),
        RepositoryProvider(
          create:
              (context) => MovieDetailsRemoteService(
                apiKey: movieDbApiKey,
                baseUrl: movieDbUrl,
                client: httpClient,
              ),
        ),
      ],
      child: child,
    );
  }
}
