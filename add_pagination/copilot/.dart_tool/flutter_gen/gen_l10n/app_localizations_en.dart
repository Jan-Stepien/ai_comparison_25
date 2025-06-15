// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Movie Browser';

  @override
  String get searchHint => 'Search...';

  @override
  String get error => 'Error';

  @override
  String get initial => 'Initial';

  @override
  String get budget => 'Budget';

  @override
  String get revenue => 'Revenue';

  @override
  String get shouldWatchToday => 'Should I watch it today?';

  @override
  String get yes => 'Yes!';

  @override
  String get no => 'No!';

  @override
  String rating(String rating) {
    return '$rating%';
  }

  @override
  String ratingWithStar(String rating) {
    return '$rating 🌟';
  }

  @override
  String get appName => 'Movie Browser';
}
