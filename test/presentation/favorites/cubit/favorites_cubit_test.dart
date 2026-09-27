import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:medication_app/core/error/failure.dart';
import 'package:medication_app/core/utils/result.dart';
import 'package:medication_app/domain/entities/medication.dart';
import 'package:medication_app/domain/usecases/remove_favorite.dart';
import 'package:medication_app/domain/usecases/watch_favorites.dart';
import 'package:medication_app/presentation/favorites/cubit/favorites_cubit.dart';
import 'package:medication_app/presentation/favorites/cubit/favorites_state.dart';

class MockWatchFavorites extends Mock implements WatchFavorites {}

class MockRemoveFavorite extends Mock implements RemoveFavorite {}

void main() {
  late MockWatchFavorites watchFavorites;
  late MockRemoveFavorite removeFavorite;
  late StreamController<Result<List<Medication>>> favorites;

  const advil = Medication(id: '1', brandName: 'advil');
  const tylenol = Medication(id: '2', brandName: 'Tylenol');
  const storage = UnknownFailure('hive error');

  setUp(() {
    watchFavorites = MockWatchFavorites();
    removeFavorite = MockRemoveFavorite();
    favorites = StreamController<Result<List<Medication>>>();
    when(() => watchFavorites()).thenAnswer((_) => favorites.stream);
  });

  tearDown(() => unawaited(favorites.close()));

  FavoritesCubit buildCubit() =>
      FavoritesCubit(watchFavorites: watchFavorites, removeFavorite: removeFavorite);

  test('initial state is FavoritesLoading', () {
    expect(buildCubit().state, FavoritesLoading());
  });

  group('start', () {
    blocTest<FavoritesCubit, FavoritesState>(
      'emits Loaded sorted by name, ignoring letter case',
      build: buildCubit,
      act: (cubit) {
        cubit.start();
        favorites.add(const Ok([tylenol, advil]));
      },
      expect: () => [FavoritesLoading(), const FavoritesLoaded([advil, tylenol])],
    );

    blocTest<FavoritesCubit, FavoritesState>(
      'emits Empty when there are no favorites',
      build: buildCubit,
      act: (cubit) {
        cubit.start();
        favorites.add(const Ok([]));
      },
      expect: () => [FavoritesLoading(), FavoritesEmpty()],
    );

    blocTest<FavoritesCubit, FavoritesState>(
      'updates the list every time storage changes',
      build: buildCubit,
      act: (cubit) {
        cubit.start();
        favorites.add(const Ok([advil]));
        favorites.add(const Ok([advil, tylenol]));
        favorites.add(const Ok([]));
      },
      expect: () => [
        FavoritesLoading(),
        const FavoritesLoaded([advil]),
        const FavoritesLoaded([advil, tylenol]),
        FavoritesEmpty(),
      ],
    );

    blocTest<FavoritesCubit, FavoritesState>(
      'emits Error when reading storage fails',
      build: buildCubit,
      act: (cubit) {
        cubit.start();
        favorites.add(const Err(storage));
      },
      expect: () => [FavoritesLoading(), const FavoritesError(storage)],
    );
  });

  group('remove', () {
    test('returns true and calls RemoveFavorite when removal succeeds', () async {
      when(() => removeFavorite('1')).thenAnswer((_) async => const Ok(null));

      expect(await buildCubit().remove('1'), isTrue);
      verify(() => removeFavorite('1')).called(1);
    });

    test('returns false when removal fails', () async {
      when(() => removeFavorite('1')).thenAnswer((_) async => const Err(storage));

      expect(await buildCubit().remove('1'), isFalse);
    });
  });

  test('stops listening to storage when closed', () async {
    var cancelled = false;
    favorites = StreamController<Result<List<Medication>>>(onCancel: () => cancelled = true);
    when(() => watchFavorites()).thenAnswer((_) => favorites.stream);

    final cubit = buildCubit()..start();
    await cubit.close();

    expect(cancelled, isTrue);
  });
}
