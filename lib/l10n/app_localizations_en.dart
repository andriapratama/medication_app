// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Medication Reference';

  @override
  String get medicationListTitle => 'Medications';

  @override
  String get emptyStateMessage => 'No medications found';

  @override
  String get errorRetryButton => 'Retry';

  @override
  String get medicationNameUnavailable => 'Name unavailable';

  @override
  String get manufacturerUnavailable => 'Manufacturer unknown';

  @override
  String get bottomNavMedications => 'Medications';

  @override
  String get bottomNavFavorites => 'Favorites';

  @override
  String get favoritesScreenTitle => 'Favorites';

  @override
  String get favoritesEmpty =>
      'No favorites yet. Tap the star on a medication\'s detail page to save it here.';

  @override
  String get favoritesRemoved => 'Removed from favorites';

  @override
  String get favoritesRemoveFailed =>
      'Couldn\'t remove from favorites. Please try again.';

  @override
  String get searchHint => 'Search by name, brand, or active ingredient';

  @override
  String get searchClear => 'Clear search';

  @override
  String get errorNetwork =>
      'No internet connection. Check your connection and try again.';

  @override
  String get errorServer =>
      'The server is having problems. Please try again later.';

  @override
  String get errorRateLimit =>
      'Too many requests. Please wait a moment and try again.';

  @override
  String get errorInvalidData => 'The data received could not be read.';

  @override
  String get errorUnknown => 'Something went wrong. Please try again.';

  @override
  String get detailBack => 'Back';

  @override
  String get detailAddFavorite => 'Add to favorites';

  @override
  String get detailRemoveFavorite => 'Remove from favorites';

  @override
  String get badgeOtc => 'OTC';

  @override
  String get badgePrescription => 'Rx';

  @override
  String get sectionPurpose => 'Purpose';

  @override
  String get sectionDosage => 'Dosage & Administration';

  @override
  String get sectionActiveIngredients => 'Active Ingredients';

  @override
  String get sectionWarnings => 'Warnings';

  @override
  String get sectionInactiveIngredients => 'Inactive Ingredients';

  @override
  String get medicalDisclaimer =>
      'This information is for technical reference only and is not a substitute for professional medical advice.';
}
