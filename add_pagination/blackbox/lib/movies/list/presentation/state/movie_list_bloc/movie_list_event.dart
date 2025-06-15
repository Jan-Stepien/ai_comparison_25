part of 'movie_list_bloc.dart';

abstract class MovieListEvent {
  const MovieListEvent();
}

class SearchMovies extends MovieListEvent {
  final String query;

  const SearchMovies(this.query);
}

class LoadMoreMovies extends MovieListEvent {
  const LoadMoreMovies();
}

class ResultChanged extends MovieListEvent {
  final List<MovieListItem> movies;
  final bool hasReachedEnd;

  const ResultChanged(this.movies, {this.hasReachedEnd = false});
}

class CreateMovieRequested extends MovieListEvent {
  const CreateMovieRequested();
}
