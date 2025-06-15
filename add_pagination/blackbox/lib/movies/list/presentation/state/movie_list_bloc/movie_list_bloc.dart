import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blackbox/movies/list/domain/models/movie_list_item.dart';
import 'package:blackbox/movies/list/domain/repositories/movie_list_repository.dart';
import 'package:blackbox/shared/presentation/models/loading_status.dart';

part 'movie_list_event.dart';
part 'movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final MovieListRepository _movieListRepository;

  MovieListBloc({
    required MovieListRepository movieListRepository,
  })  : _movieListRepository = movieListRepository,
        super(const MovieListState(
          loadingStatus: LoadingStatus.initial,
          movies: <MovieListItem>[],
        )) {
    on<SearchMovies>(_onSearchMovies);
    on<LoadMoreMovies>(_onLoadMoreMovies);
    on<ResultChanged>(_onResultChanged);
    on<CreateMovieRequested>(_onCreateMovieRequested);

    _movieListRepository.stream.listen((movies) {
      add(ResultChanged(movies));
    });
  }

  Future<void> _onSearchMovies(
    SearchMovies event,
    Emitter<MovieListState> emit,
  ) async {
    emit(state.copyWith(
      loadingStatus: LoadingStatus.loading,
      currentQuery: event.query,
      currentPage: 1,
      hasReachedEnd: false,
    ));

    try {
      final hasReachedEnd = await _movieListRepository.searchMovies(
        query: event.query,
        page: 1,
        shouldReplace: true,
      );
      emit(state.copyWith(
        loadingStatus: LoadingStatus.loaded,
        hasReachedEnd: hasReachedEnd,
      ));
    } catch (e) {
      emit(state.copyWith(
        loadingStatus: LoadingStatus.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLoadMoreMovies(
    LoadMoreMovies event,
    Emitter<MovieListState> emit,
  ) async {
    if (state.isLoadingMore || state.hasReachedEnd) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      final nextPage = state.currentPage + 1;
      final hasReachedEnd = await _movieListRepository.loadMore(nextPage);

      emit(state.copyWith(
        currentPage: nextPage,
        hasReachedEnd: hasReachedEnd,
        isLoadingMore: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isLoadingMore: false,
      ));
    }
  }

  FutureOr<void> _onResultChanged(
    ResultChanged event,
    Emitter<MovieListState> emit,
  ) {
    emit(state.copyWith(
      movies: event.movies,
      loadingStatus:
          event.movies.isNotEmpty ? LoadingStatus.loaded : state.loadingStatus,
    ));
  }

  FutureOr<void> _onCreateMovieRequested(
    CreateMovieRequested event,
    Emitter<MovieListState> emit,
  ) {
    // TODO(jan-stepien): implement create movie in other bloc
  }
}
