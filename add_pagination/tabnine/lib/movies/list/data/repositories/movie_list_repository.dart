Future<MovieList> getMovies({
  required String query,
  int page = 1,
}) async {
  try {
    // Try to get from local storage first
    final localMovies = await _localService.getMovies(query: query, page: page);
    if (localMovies != null) {
      return localMovies;
    }

    // If not available locally, fetch from remote
    final remoteMovies = await _remoteService.getMovies(query: query, page: page);
    
    // Save to local storage
    await _localService.saveMovies(query: query, page: page, movies: remoteMovies);
    
    return remoteMovies;
  } catch (e) {
    rethrow;
  }
}