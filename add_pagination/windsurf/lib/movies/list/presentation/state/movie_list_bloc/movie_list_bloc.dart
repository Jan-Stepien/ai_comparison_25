import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windsurf/movies/list/domain/models/movie_list_item.dart';
import 'package:windsurf/movies/list/domain/repositories/movie_list_repository.dart';
import 'package:windsurf/shared/presentation/models/loading_status.dart';

part 'movie_list_event.dart';
part 'movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final MovieListRepository _movieListRepository;

  MovieListBloc({required MovieListRepository movieListRepository})
    : _movieListRepository = movieListRepository,
      super(
        const MovieListState(
          loadingStatus: LoadingStatus.initial,
          movies: <MovieListItem>[],
        ),
      ) {
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
    emit(state.copyWith(loadingStatus: LoadingStatus.loading, currentPage: 1, totalPages: 1));
    try {
      final movieList = await _movieListRepository.searchMovies(query: event.query, page: 1, shouldReplace: true);
      emit(state.copyWith(
        loadingStatus: LoadingStatus.loaded,
        movies: movieList.results,
        currentPage: movieList.page,
        totalPages: movieList.totalPages,
        error: null,
      ));
    } catch (e) {
      emit(
        state.copyWith(loadingStatus: LoadingStatus.error, error: e.toString()),
      );
    }
  }

  Future<void> _onLoadMoreMovies(
    LoadMoreMovies event,
    Emitter<MovieListState> emit,
  ) async {
    if (state.isLoadingMore || state.currentPage >= state.totalPages) return;
    emit(state.copyWith(isLoadingMore: true, loadingStatus: LoadingStatus.loadingMore));
    try {
      final movieList = await _movieListRepository.searchMovies(query: event.query, page: event.page, shouldReplace: false);
      final List<MovieListItem> updatedList = List.from(state.movies)..addAll(movieList.results);
      emit(state.copyWith(
        movies: updatedList,
        currentPage: movieList.page,
        totalPages: movieList.totalPages,
        isLoadingMore: false,
        loadingStatus: LoadingStatus.loaded,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false, loadingStatus: LoadingStatus.error, error: e.toString()));
    }
  }

  FutureOr<void> _onResultChanged(
    ResultChanged event,
    Emitter<MovieListState> emit,
  ) {
    emit(
      state.copyWith(
        movies: event.movies,
        loadingStatus:
            event.movies.isNotEmpty
                ? LoadingStatus.loaded
                : state.loadingStatus,
      ),
    );
  }

  FutureOr<void> _onCreateMovieRequested(
    CreateMovieRequested event,
    Emitter<MovieListState> emit,
  ) {
    // TODO(jan-stepien): implement create movie in other bloc
  }
}
