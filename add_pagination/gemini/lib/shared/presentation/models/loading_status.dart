enum LoadingStatus {
  initial,
  loading,
  loadingMore,
  loaded,
  error,
}

extension LoadingStatusX on LoadingStatus {
  bool get isInitial => this == LoadingStatus.initial;
  bool get isLoading => this == LoadingStatus.loading;
  bool get isLoadingMore => this == LoadingStatus.loadingMore;
  bool get isLoaded => this == LoadingStatus.loaded;
  bool get isError => this == LoadingStatus.error;
}
