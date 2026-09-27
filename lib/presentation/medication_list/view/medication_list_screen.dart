import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';

// TEMPORARY placeholder until Phase 6.1; the button opens a sample detail page to test routing.
class MedicationListScreen extends StatelessWidget {
  const MedicationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.medicationListTitle)),
      body: Center(
        child: IconButton(
          icon: const Icon(Icons.open_in_new),
          onPressed: () => context.push('/medications/sample-id'),
        ),
      ),
    );
  }
}
