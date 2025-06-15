import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trae/core/extensions/build_context_extension.dart';
import 'package:trae/movies/details/domain/repositories/movie_details_repository.dart';
import 'package:trae/movies/details/presentation/state/movie_details_bloc/movie_details_bloc.dart';
import 'package:trae/movies/details/presentation/widgets/movie_detail_item.dart';
import 'package:trae/shared/presentation/models/loading_status.dart';

class MovieDetailsPage extends StatelessWidget {
  const MovieDetailsPage({super.key, required this.movieId});

  final int? movieId;

  static const routePath = '/details';

  @override
  Widget build(BuildContext context) {
    final safeMovieId = movieId;

    if (safeMovieId == null) {
      return Scaffold(
        body: Center(
          child: Text(context.l10n.error),
        ),
      );
    }

    return BlocProvider(
      create: (context) => MovieDetailsBloc(
        movieId: safeMovieId,
        movieDetailsRepository: context.read<MovieDetailsRepository>(),
      ),
      child: const MovieDetailsView(),
    );
  }
}

class MovieDetailsView extends StatelessWidget {
  const MovieDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final status =
        context.select((MovieDetailsBloc bloc) => bloc.state.loadingStatus);
    final details =
        context.select((MovieDetailsBloc bloc) => bloc.state.details);
    final shouldWatch =
        context.select((MovieDetailsBloc bloc) => bloc.state.shouldWatch);

    return Scaffold(
      appBar: AppBar(
        title: Text(details?.title ?? ''),
      ),
      body: switch (status) {
        LoadingStatus.loaded || LoadingStatus.loadingMore => ListView(
            children: [
              MovieDetailItem(
                label: context.l10n.budget,
                value: '\$${details?.budget?.toString() ?? ''}',
              ),
              const Divider(),
              MovieDetailItem(
                label: context.l10n.revenue,
                value: '\$${details?.revenue?.toString() ?? ''}',
              ),
              const Divider(),
              MovieDetailItem(
                label: context.l10n.shouldWatchToday,
                value: shouldWatch ? context.l10n.yes : context.l10n.no,
              ),
            ],
          ),
        LoadingStatus.loading =>
          const Center(child: CircularProgressIndicator()),
        LoadingStatus.error => Center(
            child: Text(
              context.select(
                (MovieDetailsBloc bloc) =>
                    bloc.state.error ?? context.l10n.error,
              ),
            ),
          ),
        LoadingStatus.initial => Center(
            child: Text(context.l10n.initial),
          ),
      },
    );
  }
}
