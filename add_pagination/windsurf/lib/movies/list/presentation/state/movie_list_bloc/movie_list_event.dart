part of 'movie_list_bloc.dart';

abstract class MovieListEvent {
  const MovieListEvent();
}

class LoadMoreMovies extends MovieListEvent {
  final String query;
  final int page;
  const LoadMoreMovies({required this.query, required this.page});
}

class SearchMovies extends MovieListEvent {
  final String query;

  const SearchMovies(this.query);
}

class ResultChanged extends MovieListEvent {
  final List<MovieListItem> movies;

  const ResultChanged(this.movies);
}

class CreateMovieRequested extends MovieListEvent {
  const CreateMovieRequested();
}
