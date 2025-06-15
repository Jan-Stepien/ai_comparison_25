import 'package:cursor/movies/details/domain/models/movie_details.dart';

abstract class MovieDetailsEvent {}

class FetchMovieDetails extends MovieDetailsEvent {
  final int movieId;

  FetchMovieDetails(this.movieId);
}

class DetailsChanged extends MovieDetailsEvent {
  final MovieDetails? details;

  DetailsChanged(this.details);
}
