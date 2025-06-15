import 'package:windsurf/shared/presentation/models/loading_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoadingStatus', () {
    test('isInitial', () {
      expect(LoadingStatus.initial.isInitial, isTrue);
    });
    test('isLoading', () {
      expect(LoadingStatus.loading.isLoading, isTrue);
    });
    test('isLoadingMore', () {
      expect(LoadingStatus.loadingMore.isLoadingMore, isTrue);
    });
    test('isLoaded', () {
      expect(LoadingStatus.loaded.isLoaded, isTrue);
    });
    test('isError', () {
      expect(LoadingStatus.error.isError, isTrue);
    });
  });
}
