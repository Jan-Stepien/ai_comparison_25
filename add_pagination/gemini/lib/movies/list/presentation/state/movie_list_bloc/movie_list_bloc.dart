import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini/movies/list/domain/models/movie_list_item.dart';
import 'package:gemini/movies/list/domain/repositories/movie_list_repository.dart';

part 'movie_list_event.dart';
part 'movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final MovieListRepository _movieListRepository;

  MovieListBloc({required MovieListRepository movieListRepository})
      : _movieListRepository = movieListRepository,
        super(
          const MovieListState(),
        ) {
    on<SearchMovies>(_onSearchMovies);
    on<ResultChanged>(_onResultChanged);
    on<CreateMovieRequested>(_onCreateMovieRequested);
    on<FetchMovies>(_onFetchMovies);
    on<FetchNextPageMovies>(_onFetchNextPageMovies);
    _movieListRepository.stream.listen((movies) {
      add(ResultChanged(movies));
    });
  }

  Future<void> _onSearchMovies(
    SearchMovies event,
    Emitter<MovieListState> emit,
  ) async {
    emit(state.copyWith(status: MovieStatus.loading));
    try {
      await _movieListRepository.searchMovies(query: event.query);
      emit(state.copyWith(status: MovieStatus.success));
    } catch (e) {
      emit(
        state.copyWith(status: MovieStatus.failure, errorMessage: e.toString()),
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
        status: event.movies.isNotEmpty ? MovieStatus.success : state.status,
      ),
    );
  }

  FutureOr<void> _onCreateMovieRequested(
    CreateMovieRequested event,
    Emitter<MovieListState> emit,
  ) {
    // TODO(jan-stepien): implement create movie in other bloc
  }
  Future<void> _onFetchMovies(
      FetchMovies event, Emitter<MovieListState> emit) async {
    if (event.query.isEmpty) {
      emit(const MovieListState(status: MovieStatus.initial));
      return;
    }
    emit(state.copyWith(
        status: MovieStatus.loading,
        movies: [], // Reset movies for new search
        currentPage: 1,
        hasReachedMax: false,
        currentQuery: event.query,
        errorMessage: '')); // Clear previous error
    try {
      final movies =
          await _movieListRepository.fetchMovies(event.query, page: 1);
      emit(state.copyWith(
        status: MovieStatus.success,
        movies: movies,
        currentPage: 1,
        hasReachedMax:
            movies.isEmpty, // Or based on API total_pages vs current_page
      ));
    } catch (e) {
      emit(state.copyWith(
          status: MovieStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onFetchNextPageMovies(
      FetchNextPageMovies event, Emitter<MovieListState> emit) async {
    if (state.hasReachedMax || state.status == MovieStatus.loadingMore) return;

    emit(state.copyWith(status: MovieStatus.loadingMore));

    try {
      final nextPage = state.currentPage + 1;
      final newMovies = await _movieListRepository
          .fetchMovies(state.currentQuery, page: nextPage);
      if (newMovies.isEmpty) {
        emit(state.copyWith(hasReachedMax: true, status: MovieStatus.success));
      } else {
        emit(state.copyWith(
          status: MovieStatus.success,
          movies: List.of(state.movies)..addAll(newMovies),
          currentPage: nextPage,
          hasReachedMax: newMovies
              .isEmpty, // Update based on API response if it indicates last page
        ));
      }
    } catch (e) {
      // Revert status to success to keep showing loaded items, but signal error for the new page.
      // You might want a more specific error state or a snackbar.
      emit(state.copyWith(
          status: MovieStatus.success,
          errorMessage: 'Failed to load more movies.'));
    }
  }
}
