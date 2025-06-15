import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windsurf/core/extensions/build_context_extension.dart';
import 'package:windsurf/movies/list/domain/repositories/movie_list_repository.dart';
import 'package:windsurf/movies/list/presentation/state/movie_list_bloc/movie_list_bloc.dart';
import 'package:windsurf/movies/list/presentation/widgets/movie_list_results_view.dart';
import 'package:windsurf/movies/list/presentation/widgets/movie_list_search_box.dart';

class MovieListPage extends StatelessWidget {
  static const routePath = '/movie_list';

  const MovieListPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create:
        (context) => MovieListBloc(
          movieListRepository: context.read<MovieListRepository>(),
        ),
    child: MovieListView(),
  );
}

class MovieListView extends StatelessWidget {
  const MovieListView({super.key});

  @override
  Widget build(BuildContext context) {
    final movieListBloc = context.read<MovieListBloc>();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.movie_creation_outlined),
            onPressed: () => movieListBloc.add(const CreateMovieRequested()),
          ),
        ],
        title: Text(context.l10n.appTitle),
      ),
      body: Column(
        children: <Widget>[
          MovieListSearchBox(
            onSubmitted: (query) => movieListBloc.add(SearchMovies(query)),
          ),
          MovieListResultsView(),
        ],
      ),
    );
  }
}
