// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_details_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MovieDetailsStateCWProxy {
  MovieDetailsState loadingStatus(LoadingStatus loadingStatus);

  MovieDetailsState details(MovieDetails? details);

  MovieDetailsState error(String? error);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MovieDetailsState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MovieDetailsState(...).copyWith(id: 12, name: "My name")
  /// ````
  MovieDetailsState call({
    LoadingStatus loadingStatus,
    MovieDetails? details,
    String? error,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMovieDetailsState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMovieDetailsState.copyWith.fieldName(...)`
class _$MovieDetailsStateCWProxyImpl implements _$MovieDetailsStateCWProxy {
  const _$MovieDetailsStateCWProxyImpl(this._value);

  final MovieDetailsState _value;

  @override
  MovieDetailsState loadingStatus(LoadingStatus loadingStatus) =>
      this(loadingStatus: loadingStatus);

  @override
  MovieDetailsState details(MovieDetails? details) => this(details: details);

  @override
  MovieDetailsState error(String? error) => this(error: error);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MovieDetailsState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MovieDetailsState(...).copyWith(id: 12, name: "My name")
  /// ````
  MovieDetailsState call({
    Object? loadingStatus = const $CopyWithPlaceholder(),
    Object? details = const $CopyWithPlaceholder(),
    Object? error = const $CopyWithPlaceholder(),
  }) {
    return MovieDetailsState(
      loadingStatus: loadingStatus == const $CopyWithPlaceholder()
          ? _value.loadingStatus
          // ignore: cast_nullable_to_non_nullable
          : loadingStatus as LoadingStatus,
      details: details == const $CopyWithPlaceholder()
          ? _value.details
          // ignore: cast_nullable_to_non_nullable
          : details as MovieDetails?,
      error: error == const $CopyWithPlaceholder()
          ? _value.error
          // ignore: cast_nullable_to_non_nullable
          : error as String?,
    );
  }
}

extension $MovieDetailsStateCopyWith on MovieDetailsState {
  /// Returns a callable class that can be used as follows: `instanceOfMovieDetailsState.copyWith(...)` or like so:`instanceOfMovieDetailsState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MovieDetailsStateCWProxy get copyWith =>
      _$MovieDetailsStateCWProxyImpl(this);
}
