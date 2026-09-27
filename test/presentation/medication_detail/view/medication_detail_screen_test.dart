import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:medication_app/core/di/injection_container.dart';
import 'package:medication_app/core/error/failure.dart';
import 'package:medication_app/core/utils/result.dart';
import 'package:medication_app/domain/entities/medication_detail.dart';
import 'package:medication_app/domain/usecases/add_favorite.dart';
import 'package:medication_app/domain/usecases/get_medication_detail.dart';
import 'package:medication_app/domain/usecases/remove_favorite.dart';
import 'package:medication_app/presentation/medication_detail/view/medication_detail_screen.dart';

import '../../../helpers/pump_app.dart';

class MockGetMedicationDetail extends Mock implements GetMedicationDetail {}

class MockAddFavorite extends Mock implements AddFavorite {}

class MockRemoveFavorite extends Mock implements RemoveFavorite {}

void main() {
  late MockGetMedicationDetail getDetail;
  late MockAddFavorite addFavorite;

  const detail = MedicationDetail(
    id: 'abc-123',
    brandName: 'Tylenol Extra Strength',
    genericName: 'Acetaminophen',
    manufacturer: 'Kenvue',
    type: MedicationType.otc,
    purpose: 'Pain reliever',
    dosageAndAdministration: 'Take 2 caplets every 6 hours',
    warnings: 'Liver warning',
    activeIngredients: ['Acetaminophen 500 mg'],
  );

  setUp(() {
    getDetail = MockGetMedicationDetail();
    addFavorite = MockAddFavorite();
    sl
      ..registerSingleton<GetMedicationDetail>(getDetail)
      ..registerSingleton<AddFavorite>(addFavorite)
      ..registerSingleton<RemoveFavorite>(MockRemoveFavorite());
  });

  tearDown(() => sl.reset());

  testWidgets('shows a spinner while the detail is loading', (tester) async {
    when(() => getDetail('abc-123')).thenAnswer((_) => Completer<Result<MedicationDetail>>().future);

    await tester.pumpApp(const MedicationDetailScreen(id: 'abc-123'));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byIcon(Icons.star_border), findsNothing);
  });

  testWidgets('shows a localized error and retries on tap', (tester) async {
    when(() => getDetail('abc-123')).thenAnswer((_) async => const Err(NetworkFailure('offline')));

    await tester.pumpApp(const MedicationDetailScreen(id: 'abc-123'));
    await tester.pumpAndSettle();

    expect(find.text('No internet connection. Check your connection and try again.'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    verify(() => getDetail('abc-123')).called(2);
  });

  testWidgets('shows header, badge, and sections; collapsed sections open on tap', (tester) async {
    when(() => getDetail('abc-123')).thenAnswer((_) async => const Ok(detail));

    await tester.pumpApp(const MedicationDetailScreen(id: 'abc-123'));
    await tester.pumpAndSettle();

    expect(find.text('Tylenol Extra Strength'), findsOneWidget);
    expect(find.text('Acetaminophen'), findsOneWidget);
    expect(find.text('OTC'), findsOneWidget);
    expect(find.text('Pain reliever'), findsOneWidget);
    expect(find.text('Liver warning'), findsOneWidget);
    expect(find.text('Take 2 caplets every 6 hours'), findsNothing);
    expect(find.text('Inactive Ingredients'), findsNothing);

    await tester.tap(find.text('Dosage & Administration'));
    await tester.pumpAndSettle();

    expect(find.text('Take 2 caplets every 6 hours'), findsOneWidget);
  });

  testWidgets('tapping the star saves the favorite and fills the icon', (tester) async {
    when(() => getDetail('abc-123')).thenAnswer((_) async => const Ok(detail));
    when(() => addFavorite(detail.copyWith(isFavorite: true))).thenAnswer((_) async => const Ok(null));

    await tester.pumpApp(const MedicationDetailScreen(id: 'abc-123'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.star_border));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.star), findsOneWidget);
    verify(() => addFavorite(detail.copyWith(isFavorite: true))).called(1);
  });

  testWidgets('in Indonesian, section titles also show the English name', (tester) async {
    when(() => getDetail('abc-123')).thenAnswer((_) async => const Ok(detail));

    await tester.pumpApp(const MedicationDetailScreen(id: 'abc-123'), locale: const Locale('id'));
    await tester.pumpAndSettle();

    expect(find.text('Kegunaan · Purpose'), findsOneWidget);
    expect(find.text('Kembali'), findsOneWidget);
  });
}
