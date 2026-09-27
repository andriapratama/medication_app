import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/injection_container.dart';
import '../../../domain/entities/medication.dart';
import '../../../l10n/app_localizations.dart';
import '../../medication_list/view/medication_list_item.dart';
import '../../shared_widgets/empty_state_widget.dart';
import '../../shared_widgets/error_state_widget.dart';
import '../../shared_widgets/loading_widget.dart';
import '../../shared_widgets/medication_card_list.dart';
import '../cubit/favorites_cubit.dart';
import '../cubit/favorites_state.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FavoritesCubit(watchFavorites: sl(), removeFavorite: sl())..start(),
      child: const _FavoritesView(),
    );
  }
}

class _FavoritesView extends StatelessWidget {
  const _FavoritesView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Text(
                l10n.favoritesScreenTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<FavoritesCubit, FavoritesState>(
                builder: (context, state) => switch (state) {
                  FavoritesLoading() => const LoadingWidget(),
                  FavoritesEmpty() => EmptyStateWidget(message: l10n.favoritesEmpty),
                  FavoritesError(:final failure) => ErrorStateWidget(
                    failure: failure,
                    onRetry: () => context.read<FavoritesCubit>().start(),
                  ),
                  FavoritesLoaded(:final items) => MedicationCardList(
                    itemCount: items.length,
                    itemBuilder: (context, index) => _DismissibleFavorite(medication: items[index]),
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DismissibleFavorite extends StatelessWidget {
  final Medication medication;

  const _DismissibleFavorite({required this.medication});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Dismissible(
      key: ValueKey(medication.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        final messenger = ScaffoldMessenger.of(context);
        final cubit = context.read<FavoritesCubit>();

        final removed = await cubit.remove(medication.id);
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(removed ? l10n.favoritesRemoved : l10n.favoritesRemoveFailed)),
          );
        return removed;
      },
      child: MedicationListItem(
        medication: medication,
        onTap: () => context.push('/medications/${medication.id}'),
      ),
    );
  }
}
