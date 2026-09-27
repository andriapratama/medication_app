import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/result.dart';
import '../../../domain/entities/medication.dart';
import '../../../domain/usecases/remove_favorite.dart';
import '../../../domain/usecases/watch_favorites.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final WatchFavorites watchFavorites;
  final RemoveFavorite removeFavorite;

  StreamSubscription<Result<List<Medication>>>? _subscription;

  FavoritesCubit({required this.watchFavorites, required this.removeFavorite})
    : super(FavoritesLoading());

  void start() {
    _subscription?.cancel();
    emit(FavoritesLoading());
    _subscription = watchFavorites().listen(_onFavoritesChanged);
  }

  void _onFavoritesChanged(Result<List<Medication>> result) {
    switch (result) {
      case Ok(value: final items):
        if (items.isEmpty) {
          emit(FavoritesEmpty());
          return;
        }
        final sorted = [...items]..sort((a, b) => _sortKey(a).compareTo(_sortKey(b)));
        emit(FavoritesLoaded(sorted));
      case Err(failure: final failure):
        emit(FavoritesError(failure));
    }
  }

  static String _sortKey(Medication m) => (m.brandName ?? m.genericName ?? '').toLowerCase();

  Future<bool> remove(String id) async {
    final result = await removeFavorite(id);
    return result is Ok;
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
