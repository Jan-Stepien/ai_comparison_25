import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zed/movies/list/domain/models/movie_list_item.dart';
import 'package:zed/movies/list/domain/repositories/movie_list_repository.dart';
import 'package:zed/shared/presentation/models/loading_status.dart';

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
    on<ResultChanged>(_onResultChanged);
    on<LoadMoreMovies>(_onLoadMoreMovies);
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
      currentPage: 1,
      hasReachedMax: false,
      lastQuery: event.query,
    ));
    try {
      await _movieListRepository.searchMovies(
        query: event.query,
        page: 1,
      );
      emit(state.copyWith(loadingStatus: LoadingStatus.loaded));
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
    if (state.hasReachedMax || state.loadingStatus == LoadingStatus.loadingMore) {
      return;
    }

    emit(state.copyWith(loadingStatus: LoadingStatus.loadingMore));
    try {
      final nextPage = state.currentPage + 1;
      final hasMore = await _movieListRepository.searchMovies(
        query: state.lastQuery,
        page: nextPage,
        shouldReplace: false,
      );

      emit(state.copyWith(
        loadingStatus: LoadingStatus.loaded,
        currentPage: nextPage,
        hasReachedMax: !hasMore,
      ));
    } catch (e) {
      emit(state.copyWith(
        loadingStatus: LoadingStatus.loaded,
        error: e.toString(),
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
      CreateMovieRequested event, Emitter<MovieListState> emit) {
    // TODO(jan-stepien): implement create movie in other bloc
  }
}
