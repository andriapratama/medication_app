import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:medication_app/l10n/app_localizations.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget child, {Locale locale = const Locale('en')}) {
    return pumpWidget(
      MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    );
  }
}
