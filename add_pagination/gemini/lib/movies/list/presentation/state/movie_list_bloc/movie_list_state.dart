part of 'movie_list_bloc.dart';

enum MovieStatus { initial, loading, success, failure, loadingMore }

class MovieListState extends Equatable {
  const MovieListState({
    this.status = MovieStatus.initial,
    this.movies = const <MovieListItem>[],
    this.errorMessage = '',
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.currentQuery = '',
  });

  final MovieStatus status;
  final List<MovieListItem> movies;
  final String errorMessage;
  final int currentPage;
  final bool hasReachedMax;
  final String currentQuery;

  MovieListState copyWith({
    MovieStatus? status,
    List<MovieListItem>? movies,
    String? errorMessage,
    int? currentPage,
    bool? hasReachedMax,
    String? currentQuery,
  }) {
    return MovieListState(
      status: status ?? this.status,
      movies: movies ?? this.movies,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentQuery: currentQuery ?? this.currentQuery,
    );
  }

  @override
  List<Object> get props =>
      [status, movies, errorMessage, currentPage, hasReachedMax, currentQuery];
}
