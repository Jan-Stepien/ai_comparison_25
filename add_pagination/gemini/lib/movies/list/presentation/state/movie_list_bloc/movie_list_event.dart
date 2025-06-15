part of 'movie_list_bloc.dart';

abstract class MovieListEvent extends Equatable {
  const MovieListEvent();
}

class FetchMovies extends MovieListEvent {
  final String query;
  const FetchMovies(this.query);

  @override
  List<Object> get props => [query];
}

class FetchNextPageMovies extends MovieListEvent {
  // New event
  const FetchNextPageMovies();

  @override
  List<Object> get props => [];
}

class SearchMovies extends MovieListEvent {
  final String query;

  const SearchMovies(this.query);

  @override
  List<Object?> get props => [query];
}

class ResultChanged extends MovieListEvent {
  final List<MovieListItem> movies;

  const ResultChanged(this.movies);

  @override
  List<Object?> get props => [movies];
}

class CreateMovieRequested extends MovieListEvent {
  const CreateMovieRequested();

  @override
  List<Object?> get props => [];
}
