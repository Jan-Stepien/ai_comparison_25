part of 'movie_list_bloc.dart';

class MovieListState with EquatableMixin {
  final LoadingStatus loadingStatus;
  final List<MovieListItem> movies;
  final String? error;
  final int currentPage;
  final bool hasReachedEnd;
  final String currentQuery;
  final bool isLoadingMore;

  const MovieListState({
    required this.loadingStatus,
    required this.movies,
    this.error,
    this.currentPage = 1,
    this.hasReachedEnd = false,
    this.currentQuery = '',
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [
        loadingStatus,
        movies,
        error,
        currentPage,
        hasReachedEnd,
        currentQuery,
        isLoadingMore,
      ];

  MovieListState copyWith({
    LoadingStatus? loadingStatus,
    List<MovieListItem>? movies,
    String? error,
    int? currentPage,
    bool? hasReachedEnd,
    String? currentQuery,
    bool? isLoadingMore,
  }) =>
      MovieListState(
        loadingStatus: loadingStatus ?? this.loadingStatus,
        movies: movies ?? this.movies,
        error: error ?? this.error,
        currentPage: currentPage ?? this.currentPage,
        hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
        currentQuery: currentQuery ?? this.currentQuery,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      );
}
