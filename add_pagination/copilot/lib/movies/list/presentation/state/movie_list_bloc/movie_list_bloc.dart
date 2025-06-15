import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:copilot/movies/list/domain/models/movie_list_item.dart';
import 'package:copilot/movies/list/domain/repositories/movie_list_repository.dart';
import 'package:copilot/movies/list/data/services/movie_list_local_service.dart';
import 'package:copilot/shared/presentation/models/loading_status.dart';

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
    on<ResultChanged>(_onResultChanged);
    on<CreateMovieRequested>(_onCreateMovieRequested);
    on<PaginatedResultChanged>(_onPaginatedResultChanged);
    on<LoadNextPage>(_onLoadNextPage);
    on<LoadPreviousPage>(_onLoadPreviousPage);
    on<SetPage>(_onSetPage);

    _movieListRepository.stream.listen((movies) {
      add(ResultChanged(movies));
    });
    _movieListRepository.paginatedStream.listen((paginatedResults) {
      add(PaginatedResultChanged(paginatedResults));
    });
  }

  Future<void> _onSearchMovies(
    SearchMovies event,
    Emitter<MovieListState> emit,
  ) async {
    emit(state.copyWith(
      loadingStatus: LoadingStatus.loading,
      currentPage: 1,
      hasMorePages: false,
    ));
    try {
      await _movieListRepository.searchMovies(query: event.query);
      // The paginated results will be updated through the paginatedStream
      // No need to emit a state change here as it will be done in _onPaginatedResultChanged
    } catch (e) {
      emit(
        state.copyWith(loadingStatus: LoadingStatus.error, error: e.toString()),
      );
    }
  }

  FutureOr<void> _onResultChanged(
    ResultChanged event,
    Emitter<MovieListState> emit,
  ) {
    emit(
      state.copyWith(
        movies: event.movies,
        loadingStatus: event.movies.isNotEmpty
            ? LoadingStatus.loaded
            : state.loadingStatus,
      ),
    );
  }

  FutureOr<void> _onPaginatedResultChanged(
    PaginatedResultChanged event,
    Emitter<MovieListState> emit,
  ) {
    final results = event.paginatedResults;
    emit(
      state.copyWith(
        movies: results.movies,
        currentPage: results.currentPage,
        pageSize: results.pageSize,
        hasMorePages: results.hasMorePages,
        loadingStatus: LoadingStatus.loaded,
      ),
    );
  }

  FutureOr<void> _onCreateMovieRequested(
    CreateMovieRequested event,
    Emitter<MovieListState> emit,
  ) {
    // TODO(jan-stepien): implement create movie in other bloc
  }

  FutureOr<void> _onLoadNextPage(
    LoadNextPage event,
    Emitter<MovieListState> emit,
  ) async {
    if (state.hasMorePages) {
      emit(state.copyWith(loadingStatus: LoadingStatus.loadingMore));
      try {
        await _movieListRepository.getPage(state.currentPage + 1);
      } catch (e) {
        emit(state.copyWith(
            loadingStatus: LoadingStatus.error, error: e.toString()));
      }
    }
  }

  FutureOr<void> _onLoadPreviousPage(
    LoadPreviousPage event,
    Emitter<MovieListState> emit,
  ) async {
    if (state.currentPage > 1) {
      emit(state.copyWith(loadingStatus: LoadingStatus.loadingMore));
      try {
        await _movieListRepository.getPage(state.currentPage - 1);
      } catch (e) {
        emit(state.copyWith(
            loadingStatus: LoadingStatus.error, error: e.toString()));
      }
    }
  }

  FutureOr<void> _onSetPage(
    SetPage event,
    Emitter<MovieListState> emit,
  ) async {
    if (event.page != state.currentPage) {
      emit(state.copyWith(loadingStatus: LoadingStatus.loadingMore));
      try {
        await _movieListRepository.getPage(event.page);
      } catch (e) {
        emit(state.copyWith(
            loadingStatus: LoadingStatus.error, error: e.toString()));
      }
    }
  }
}
