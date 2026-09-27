import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// Title of the application
  ///
  /// In en, this message translates to:
  /// **'Medication Reference'**
  String get appTitle;

  /// Title of the medication list screen
  ///
  /// In en, this message translates to:
  /// **'Medications'**
  String get medicationListTitle;

  /// Shown when a list request succeeds but returns no results
  ///
  /// In en, this message translates to:
  /// **'No medications found'**
  String get emptyStateMessage;

  /// Button label to retry a failed request
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get errorRetryButton;

  /// Placeholder when brand/generic name is missing from openFDA data
  ///
  /// In en, this message translates to:
  /// **'Name unavailable'**
  String get medicationNameUnavailable;

  /// Placeholder when manufacturer name is missing from openFDA data
  ///
  /// In en, this message translates to:
  /// **'Manufacturer unknown'**
  String get manufacturerUnavailable;

  /// Bottom navigation label for the medication list tab
  ///
  /// In en, this message translates to:
  /// **'Medications'**
  String get bottomNavMedications;

  /// Bottom navigation label for the favorites tab
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get bottomNavFavorites;

  /// Title of the favorites screen
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoritesScreenTitle;

  /// Empty state on the favorites tab
  ///
  /// In en, this message translates to:
  /// **'No favorites yet. Tap the star on a medication\'s detail page to save it here.'**
  String get favoritesEmpty;

  /// SnackBar shown after swiping a favorite away
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get favoritesRemoved;

  /// SnackBar shown when removing a favorite fails
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t remove from favorites. Please try again.'**
  String get favoritesRemoveFailed;

  /// Placeholder text in the medication search field
  ///
  /// In en, this message translates to:
  /// **'Search by name, brand, or active ingredient'**
  String get searchHint;

  /// Tooltip/accessibility label for the button that clears the search field
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get searchClear;

  /// Shown for NetworkFailure
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Check your connection and try again.'**
  String get errorNetwork;

  /// Shown for ServerFailure (5xx)
  ///
  /// In en, this message translates to:
  /// **'The server is having problems. Please try again later.'**
  String get errorServer;

  /// Shown for RateLimitFailure (HTTP 429)
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please wait a moment and try again.'**
  String get errorRateLimit;

  /// Shown for InvalidDataFailure
  ///
  /// In en, this message translates to:
  /// **'The data received could not be read.'**
  String get errorInvalidData;

  /// Shown for UnknownFailure
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorUnknown;

  /// Back button label on the detail screen
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get detailBack;

  /// Tooltip for the star button when the medication is not a favorite
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get detailAddFavorite;

  /// Tooltip for the star button when the medication is a favorite
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get detailRemoveFavorite;

  /// Badge for over-the-counter medications
  ///
  /// In en, this message translates to:
  /// **'OTC'**
  String get badgeOtc;

  /// Badge for prescription-only medications
  ///
  /// In en, this message translates to:
  /// **'Rx'**
  String get badgePrescription;

  /// Detail section title for purpose / indications and usage
  ///
  /// In en, this message translates to:
  /// **'Purpose'**
  String get sectionPurpose;

  /// Detail section title for dosage and administration
  ///
  /// In en, this message translates to:
  /// **'Dosage & Administration'**
  String get sectionDosage;

  /// Detail section title for active ingredients
  ///
  /// In en, this message translates to:
  /// **'Active Ingredients'**
  String get sectionActiveIngredients;

  /// Detail section title for warnings
  ///
  /// In en, this message translates to:
  /// **'Warnings'**
  String get sectionWarnings;

  /// Detail section title for inactive ingredients
  ///
  /// In en, this message translates to:
  /// **'Inactive Ingredients'**
  String get sectionInactiveIngredients;

  /// Disclaimer pinned at the bottom of the detail screen
  ///
  /// In en, this message translates to:
  /// **'This information is for technical reference only and is not a substitute for professional medical advice.'**
  String get medicalDisclaimer;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
