import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blackbox/core/extensions/build_context_extension.dart';
import 'package:blackbox/movies/list/presentation/state/movie_list_bloc/movie_list_bloc.dart';
import 'package:blackbox/movies/list/presentation/widgets/movie_list_results_list.dart';
import 'package:blackbox/shared/presentation/models/loading_status.dart';

class MovieListResultsView extends StatelessWidget {
  const MovieListResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.select(
      (MovieListBloc bloc) => bloc.state.loadingStatus,
    );
    final movieList = context.select((MovieListBloc bloc) => bloc.state.movies);

    return Expanded(
      child: switch (status) {
        LoadingStatus.loaded ||
        LoadingStatus.loadingMore => MovieListResultsList(movieList: movieList),
        LoadingStatus.loading => Center(child: CircularProgressIndicator()),
        LoadingStatus.error => Center(child: Text(context.l10n.error)),
        LoadingStatus.initial => Center(child: Text(context.l10n.initial)),
      },
    );
  }
}
