import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:zed/movies/details/domain/models/movie_details.dart';
import 'package:zed/shared/presentation/models/loading_status.dart';
import 'package:clock/clock.dart';
part 'movie_details_state.g.dart';

@CopyWith()
class MovieDetailsState with EquatableMixin {
  final LoadingStatus loadingStatus;
  final MovieDetails? details;
  final String? error;

  const MovieDetailsState({
    required this.loadingStatus,
    required this.details,
    this.error,
  });

  bool get shouldWatch {
    final now = clock.now();
    if (now.weekday != 7) {
      return false;
    }
    final revenue = details?.revenue;
    final budget = details?.budget;
    if (revenue == null || budget == null) {
      return false;
    }
    return revenue - budget > 1000000;
  }

  @override
  List<Object?> get props => [loadingStatus, details, error];
}
