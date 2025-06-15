part of 'movie_list_bloc.dart';

class MovieListState with EquatableMixin {
  final LoadingStatus loadingStatus;
  final List<MovieListItem> movies;
  final String? error;
  final int currentPage;
  final bool hasReachedMax;
  final String lastQuery;

  const MovieListState({
    required this.loadingStatus,
    required this.movies,
    this.error,
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.lastQuery = '',
  });

  @override
  List<Object?> get props => [loadingStatus, movies, error, currentPage, hasReachedMax, lastQuery];

  MovieListState copyWith({
    LoadingStatus? loadingStatus,
    List<MovieListItem>? movies,
    String? error,
    int? currentPage,
    bool? hasReachedMax,
    String? lastQuery,
  }) =>
      MovieListState(
        loadingStatus: loadingStatus ?? this.loadingStatus,
        movies: movies ?? this.movies,
        error: error ?? this.error,
        currentPage: currentPage ?? this.currentPage,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        lastQuery: lastQuery ?? this.lastQuery,
      );
}
