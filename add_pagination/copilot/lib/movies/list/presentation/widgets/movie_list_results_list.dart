import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:copilot/movies/details/presentation/pages/movie_details_page.dart';
import 'package:copilot/movies/list/domain/models/movie_list_item.dart';
import 'package:copilot/movies/list/presentation/state/movie_list_bloc/movie_list_bloc.dart';
import 'package:copilot/movies/list/presentation/widgets/movie_list_card.dart';

class MovieListResultsList extends StatelessWidget {
  const MovieListResultsList({super.key, required this.movieList});

  final List<MovieListItem> movieList;

  @override
  Widget build(BuildContext context) {
    final currentPage =
        context.select((MovieListBloc bloc) => bloc.state.currentPage);
    final hasMorePages =
        context.select((MovieListBloc bloc) => bloc.state.hasMorePages);

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) =>
                Container(height: 1.0, color: Colors.grey.shade300),
            itemBuilder: (context, index) => MovieListCard(
              title: movieList[index].title,
              rating: '${(movieList[index].voteAverage * 10).toInt()}',
              onTap: () => Navigator.pushNamed(
                context,
                MovieDetailsPage.routePath,
                arguments: movieList[index].id,
              ),
            ),
            itemCount: movieList.length,
          ),
        ),
        if (movieList.isNotEmpty)
          _buildPaginationControls(context, currentPage, hasMorePages),
      ],
    );
  }

  Widget _buildPaginationControls(
      BuildContext context, int currentPage, bool hasMorePages) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: currentPage > 1
                ? () =>
                    context.read<MovieListBloc>().add(const LoadPreviousPage())
                : null,
          ),
          Text(
            'Page $currentPage',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: hasMorePages
                ? () => context.read<MovieListBloc>().add(const LoadNextPage())
                : null,
          ),
        ],
      ),
    );
  }
}
