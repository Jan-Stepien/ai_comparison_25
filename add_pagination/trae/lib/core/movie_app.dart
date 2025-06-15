import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:trae/movies/details/presentation/pages/movie_details_page.dart';
import 'package:trae/movies/list/presentation/pages/movie_list_page.dart';

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: AppLocalizations.of(context)?.appName,
    theme: ThemeData(primarySwatch: Colors.amber),
    initialRoute: MovieListPage.routePath,
    routes: {
      MovieListPage.routePath: (context) => const MovieListPage(),
      MovieDetailsPage.routePath:
          (context) => MovieDetailsPage(
            movieId: ModalRoute.of(context)?.settings.arguments as int?,
          ),
    },
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
  );
}
