import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

// TEMPORARY placeholder until Phase 6.4.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.favoritesScreenTitle)),
      body: Center(child: Text(l10n.favoritesEmpty, textAlign: TextAlign.center)),
    );
  }
}
