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

class PaginatedResultChanged extends MovieListEvent {
  final PaginatedResults paginatedResults;

  const PaginatedResultChanged(this.paginatedResults);
}

class LoadNextPage extends MovieListEvent {
  const LoadNextPage();
}

class LoadPreviousPage extends MovieListEvent {
  const LoadPreviousPage();
}

class SetPage extends MovieListEvent {
  final int page;

  const SetPage(this.page);
}
