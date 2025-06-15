import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cursor/movies/details/presentation/pages/movie_details_page.dart';
import 'package:cursor/movies/list/domain/models/movie_list_item.dart';
import 'package:cursor/movies/list/presentation/widgets/movie_list_card.dart';
import 'package:cursor/movies/list/presentation/state/movie_list_bloc/movie_list_bloc.dart';
import 'package:cursor/shared/presentation/models/loading_status.dart';

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
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    final loadingStatus = context.select(
      (MovieListBloc bloc) => bloc.state.loadingStatus,
    );
    final hasMorePages = context.select(
      (MovieListBloc bloc) => bloc.state.hasMorePages,
    );

    return ListView.separated(
      controller: _scrollController,
      separatorBuilder: (context, index) => Container(
        height: 1.0,
        color: Colors.grey.shade300,
      ),
      itemBuilder: (context, index) {
        if (index >= widget.movieList.length) {
          return _buildLoadingItem(loadingStatus, hasMorePages);
        }

        return MovieListCard(
          title: widget.movieList[index].title,
          rating: '${(widget.movieList[index].voteAverage * 10).toInt()}',
          onTap: () => Navigator.pushNamed(
            context,
            MovieDetailsPage.routePath,
            arguments: widget.movieList[index].id,
          ),
        );
      },
      itemCount: widget.movieList.length +
          (hasMorePages && loadingStatus == LoadingStatus.loadingMore ? 1 : 0),
    );
  }

  Widget _buildLoadingItem(LoadingStatus loadingStatus, bool hasMorePages) {
    if (loadingStatus == LoadingStatus.loadingMore && hasMorePages) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
