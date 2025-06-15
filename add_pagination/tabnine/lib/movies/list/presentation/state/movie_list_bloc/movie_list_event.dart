part of 'movie_list_bloc.dart';

abstract class MovieListEvent {
  const MovieListEvent();
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
