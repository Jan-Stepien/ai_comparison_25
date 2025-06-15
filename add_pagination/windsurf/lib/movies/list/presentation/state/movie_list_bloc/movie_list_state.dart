part of 'movie_list_bloc.dart';

class MovieListState with EquatableMixin {
  final LoadingStatus loadingStatus;
  final List<MovieListItem> movies;
  final String? error;
  final int currentPage;
  final int totalPages;
  final bool isLoadingMore;

  const MovieListState({
    required this.loadingStatus,
    required this.movies,
    this.error,
    this.currentPage = 1,
    this.totalPages = 1,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [loadingStatus, movies, error, currentPage, totalPages, isLoadingMore];

  MovieListState copyWith({
    LoadingStatus? loadingStatus,
    List<MovieListItem>? movies,
    String? error,
    int? currentPage,
    int? totalPages,
    bool? isLoadingMore,
  }) =>
      MovieListState(
        loadingStatus: loadingStatus ?? this.loadingStatus,
        movies: movies ?? this.movies,
        error: error ?? this.error,
        currentPage: currentPage ?? this.currentPage,
        totalPages: totalPages ?? this.totalPages,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      );
}
