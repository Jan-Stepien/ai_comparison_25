part of 'movie_list_bloc.dart';

class MovieListState with EquatableMixin {
  final LoadingStatus loadingStatus;
  final List<MovieListItem> movies;
  final bool hasMorePages;
  final String? error;

  const MovieListState({
    required this.loadingStatus,
    required this.movies,
    required this.hasMorePages,
    this.error,
  });

  @override
  List<Object?> get props => [loadingStatus, movies, hasMorePages, error];

  MovieListState copyWith({
    LoadingStatus? loadingStatus,
    List<MovieListItem>? movies,
    bool? hasMorePages,
    String? error,
  }) =>
      MovieListState(
        loadingStatus: loadingStatus ?? this.loadingStatus,
        movies: movies ?? this.movies,
        hasMorePages: hasMorePages ?? this.hasMorePages,
        error: error ?? this.error,
      );
}
