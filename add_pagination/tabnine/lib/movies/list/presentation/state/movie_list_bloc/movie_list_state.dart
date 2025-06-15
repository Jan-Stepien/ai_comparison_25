part of 'movie_list_bloc.dart';

class MovieListState with EquatableMixin {
  final LoadingStatus loadingStatus;
  final List<MovieListItem> movies;
  final String? error;

  const MovieListState({
    required this.loadingStatus,
    required this.movies,
    this.error,
  });

  @override
  List<Object?> get props => [loadingStatus, movies, error];

  MovieListState copyWith({
    LoadingStatus? loadingStatus,
    List<MovieListItem>? movies,
    String? error,
  }) =>
      MovieListState(
        loadingStatus: loadingStatus ?? this.loadingStatus,
        movies: movies ?? this.movies,
        error: error ?? this.error,
      );
}
