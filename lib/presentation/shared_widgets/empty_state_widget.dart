import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class EmptyStateWidget extends StatelessWidget {
  final String? message;

  const EmptyStateWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Text(
          message ?? AppLocalizations.of(context)!.emptyStateMessage,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
