import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini/movies/details/presentation/pages/movie_details_page.dart';
import 'package:gemini/movies/list/domain/models/movie_list_item.dart';
import 'package:gemini/movies/list/presentation/state/movie_list_bloc/movie_list_bloc.dart';
import 'package:gemini/movies/list/presentation/widgets/movie_list_card.dart';

class MovieListResultsList extends StatefulWidget {
  const MovieListResultsList({super.key, required this.movieList});

  final List<MovieListItem> movieList;

  @override
  State<MovieListResultsList> createState() => _MovieListResultsListState();
}

class _MovieListResultsListState extends State<MovieListResultsList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.9 &&
        context.read<MovieListBloc>().state.status != MovieStatus.loadingMore) {
      context.read<MovieListBloc>().add(const FetchNextPageMovies());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieListBloc, MovieListState>(
      builder: (context, state) => ListView.builder(
        controller: _scrollController,
        itemCount:
            state.hasReachedMax ? state.movies.length : state.movies.length + 1,
        itemBuilder: (context, index) {
          if (index >= state.movies.length) {
            // Loader item at the bottom
            return state.status == MovieStatus.loadingMore
                ? const Center(
                    child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ))
                : const SizedBox
                    .shrink(); // Or some other indicator if not loading more but not reached max
          }
          // Movie item
          final movie = state.movies[index];
          return ListTile(
            title: Text(movie.title), // Assuming Movie model has 'title'
            subtitle: Text(movie.overview ??
                'No overview available'), // Assuming Movie model has 'overview'
            // leading: movie.posterPath != null
            //     ? Image.network('https://image.tmdb.org/t/p/w92${movie.posterPath}')
            //     : const Icon(Icons.movie),
          );
        },
      ),
    );
  }
}
