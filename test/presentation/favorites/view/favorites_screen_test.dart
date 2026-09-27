import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:medication_app/core/di/injection_container.dart';
import 'package:medication_app/core/utils/result.dart';
import 'package:medication_app/domain/entities/medication.dart';
import 'package:medication_app/domain/usecases/remove_favorite.dart';
import 'package:medication_app/domain/usecases/watch_favorites.dart';
import 'package:medication_app/presentation/favorites/view/favorites_screen.dart';

import '../../../helpers/pump_app.dart';

class MockWatchFavorites extends Mock implements WatchFavorites {}

class MockRemoveFavorite extends Mock implements RemoveFavorite {}

void main() {
  late MockRemoveFavorite removeFavorite;
  late StreamController<Result<List<Medication>>> favorites;

  const advil = Medication(id: '1', brandName: 'Advil', genericName: 'IBUPROFEN', manufacturer: 'Pfizer');

  setUp(() {
    final watchFavorites = MockWatchFavorites();
    removeFavorite = MockRemoveFavorite();
    favorites = StreamController<Result<List<Medication>>>();
    when(() => watchFavorites()).thenAnswer((_) => favorites.stream);
    sl
      ..registerSingleton<WatchFavorites>(watchFavorites)
      ..registerSingleton<RemoveFavorite>(removeFavorite);
  });

  tearDown(() async {
    unawaited(favorites.close());
    await sl.reset();
  });

  testWidgets('shows the favorites hint when there are none', (tester) async {
    await tester.pumpApp(const FavoritesScreen());
    favorites.add(const Ok([]));
    await tester.pumpAndSettle();

    expect(
      find.text("No favorites yet. Tap the star on a medication's detail page to save it here."),
      findsOneWidget,
    );
  });

  testWidgets('swiping a favorite removes it and shows a confirmation', (tester) async {
    when(() => removeFavorite('1')).thenAnswer((_) async {
      favorites.add(const Ok([]));
      return const Ok(null);
    });

    await tester.pumpApp(const FavoritesScreen());
    favorites.add(const Ok([advil]));
    await tester.pumpAndSettle();
    expect(find.text('Advil'), findsOneWidget);

    await tester.drag(find.text('Advil'), const Offset(-600, 0));
    await tester.pumpAndSettle();

    verify(() => removeFavorite('1')).called(1);
    expect(find.text('Advil'), findsNothing);
    expect(find.text('Removed from favorites'), findsOneWidget);
  });
}
