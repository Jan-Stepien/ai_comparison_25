import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zed/movies/details/presentation/pages/movie_details_page.dart';
import 'package:zed/movies/list/domain/models/movie_list_item.dart';
import 'package:zed/movies/list/presentation/state/movie_list_bloc/movie_list_bloc.dart';
import 'package:zed/movies/list/presentation/widgets/movie_list_card.dart';
import 'package:zed/shared/presentation/models/loading_status.dart';

class MovieListResultsList extends StatefulWidget {
  const MovieListResultsList({super.key, required this.movieList});

  final List<MovieListItem> movieList;

  @override
  State<MovieListResultsList> createState() => _MovieListResultsListState();
}

class _MovieListResultsListState extends State<MovieListResultsList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<MovieListBloc>().add(const LoadMoreMovies());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    // Load more when user scrolls to 80% of the list
    return currentScroll >= (maxScroll * 0.8);
  }

  @override
  Widget build(BuildContext context) {
    final isLoadingMore = context.select(
      (MovieListBloc bloc) => bloc.state.loadingStatus == LoadingStatus.loadingMore,
    );

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            controller: _scrollController,
            separatorBuilder: (context, index) => Container(
              height: 1.0,
              color: Colors.grey.shade300,
            ),
            itemBuilder: (context, index) => MovieListCard(
              title: widget.movieList[index].title,
              rating: '${(widget.movieList[index].voteAverage * 10).toInt()}',
              onTap: () => Navigator.pushNamed(
                context,
                MovieDetailsPage.routePath,
                arguments: widget.movieList[index].id,
              ),
            ),
            itemCount: widget.movieList.length,
          ),
        ),
        if (isLoadingMore)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
