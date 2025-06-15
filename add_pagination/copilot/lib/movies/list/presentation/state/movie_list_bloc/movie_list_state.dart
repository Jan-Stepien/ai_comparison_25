part of 'movie_list_bloc.dart';

class MovieListState with EquatableMixin {
  final LoadingStatus loadingStatus;
  final List<MovieListItem> movies;
  final String? error;
  final int currentPage;
  final int pageSize;
  final bool hasMorePages;

  const MovieListState({
    required this.loadingStatus,
    required this.movies,
    this.error,
    this.currentPage = 1,
    this.pageSize = 10,
    this.hasMorePages = false,
  });

  @override
  List<Object?> get props =>
      [loadingStatus, movies, error, currentPage, pageSize, hasMorePages];

  MovieListState copyWith({
    LoadingStatus? loadingStatus,
    List<MovieListItem>? movies,
    String? error,
    int? currentPage,
    int? pageSize,
    bool? hasMorePages,
  }) =>
      MovieListState(
        loadingStatus: loadingStatus ?? this.loadingStatus,
        movies: movies ?? this.movies,
        error: error ?? this.error,
        currentPage: currentPage ?? this.currentPage,
        pageSize: pageSize ?? this.pageSize,
        hasMorePages: hasMorePages ?? this.hasMorePages,
      );
}
