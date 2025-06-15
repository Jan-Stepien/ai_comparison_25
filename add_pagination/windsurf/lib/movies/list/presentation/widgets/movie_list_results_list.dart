import 'package:flutter/material.dart';
import 'package:windsurf/movies/details/presentation/pages/movie_details_page.dart';
import 'package:windsurf/movies/list/domain/models/movie_list_item.dart';
import 'package:windsurf/movies/list/presentation/widgets/movie_list_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windsurf/movies/list/presentation/state/movie_list_bloc/movie_list_bloc.dart';

class MovieListResultsList extends StatefulWidget {
  const MovieListResultsList({super.key, required this.movieList});

  final List<MovieListItem> movieList;

  @override
  State<MovieListResultsList> createState() => _MovieListResultsListState();
}

class _MovieListResultsListState extends State<MovieListResultsList> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final bloc = BlocProvider.of<MovieListBloc>(context);
    final state = bloc.state;
    if (!_scrollController.hasClients || state.isLoadingMore) return;
    final threshold = 200.0;
    if (_scrollController.position.extentAfter < threshold &&
        state.currentPage < state.totalPages) {
      // We assume the query is tracked in state.error for now, but ideally should be a dedicated field
      final query = state.error ?? '';
      bloc.add(LoadMoreMovies(query: query, page: state.currentPage + 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MovieListBloc>(context);
    final state = bloc.state;
    final isLoadingMore = state.isLoadingMore;
    final movies = widget.movieList;
    return ListView.separated(
      controller: _scrollController,
      separatorBuilder: (context, index) =>
          Container(height: 1.0, color: Colors.grey.shade300),
      itemBuilder: (context, index) {
        if (index == movies.length) {
          return isLoadingMore
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(child: CircularProgressIndicator()),
                )
              : const SizedBox.shrink();
        }
        final movie = movies[index];
        return MovieListCard(
          title: movie.title,
          rating: '${(movie.voteAverage * 10).toInt()}',
          onTap: () => Navigator.pushNamed(
            context,
            MovieDetailsPage.routePath,
            arguments: movie.id,
          ),
        );
      },
      itemCount: movies.length + (isLoadingMore ? 1 : 0),
    );
  }
}

