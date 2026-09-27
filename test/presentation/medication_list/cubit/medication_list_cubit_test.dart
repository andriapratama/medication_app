import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:medication_app/core/error/failure.dart';
import 'package:medication_app/core/utils/result.dart';
import 'package:medication_app/domain/entities/medication.dart';
import 'package:medication_app/domain/usecases/get_medications.dart';
import 'package:medication_app/presentation/medication_list/cubit/medication_list_cubit.dart';
import 'package:medication_app/presentation/medication_list/cubit/medication_list_state.dart';

class MockGetMedications extends Mock implements GetMedications {}

List<Medication> page(int count, {int start = 0}) =>
    List.generate(count, (i) => Medication(id: '${start + i}'));

void main() {
  late MockGetMedications getMedications;

  final firstPage = page(20);
  final secondPage = page(5, start: 20);
  const rateLimit = RateLimitFailure('rate limited');
  const network = NetworkFailure('offline');

  setUp(() {
    getMedications = MockGetMedications();
  });

  void stubPage(int skip, Result<List<Medication>> result) {
    when(
      () => getMedications(limit: 20, skip: skip),
    ).thenAnswer((_) async => result);
  }

  test('initial state is MedicationListInitial', () {
    expect(MedicationListCubit(getMedications).state, MedicationListInitial());
  });

  group('fetchMedications', () {
    blocTest<MedicationListCubit, MedicationListState>(
      'emits [Loading, Loaded] with hasReachedMax false on a full page',
      setUp: () => stubPage(0, Ok(firstPage)),
      build: () => MedicationListCubit(getMedications),
      act: (cubit) => cubit.fetchMedications(),
      expect: () => [
        MedicationListLoading(),
        MedicationListLoaded(items: firstPage, hasReachedMax: false),
      ],
    );

    blocTest<MedicationListCubit, MedicationListState>(
      'emits [Loading, Loaded] with hasReachedMax true on a partial page',
      setUp: () => stubPage(0, Ok(secondPage)),
      build: () => MedicationListCubit(getMedications),
      act: (cubit) => cubit.fetchMedications(),
      expect: () => [
        MedicationListLoading(),
        MedicationListLoaded(items: secondPage, hasReachedMax: true),
      ],
    );

    blocTest<MedicationListCubit, MedicationListState>(
      'emits [Loading, Empty] when no medications are returned',
      setUp: () => stubPage(0, const Ok([])),
      build: () => MedicationListCubit(getMedications),
      act: (cubit) => cubit.fetchMedications(),
      expect: () => [MedicationListLoading(), MedicationListEmpty()],
    );

    blocTest<MedicationListCubit, MedicationListState>(
      'emits [Loading, Error(RateLimitFailure)] when rate limited (429)',
      setUp: () => stubPage(0, const Err(rateLimit)),
      build: () => MedicationListCubit(getMedications),
      act: (cubit) => cubit.fetchMedications(),
      expect: () => [MedicationListLoading(), const MedicationListError(rateLimit)],
    );
  });

  group('fetchMore', () {
    blocTest<MedicationListCubit, MedicationListState>(
      'appends the next page using skip = items already loaded',
      setUp: () {
        stubPage(0, Ok(firstPage));
        stubPage(20, Ok(secondPage));
      },
      build: () => MedicationListCubit(getMedications),
      act: (cubit) async {
        await cubit.fetchMedications();
        await cubit.fetchMore();
      },
      skip: 2,
      expect: () => [
        MedicationListLoaded(
          items: [...firstPage, ...secondPage],
          hasReachedMax: true,
        ),
      ],
      verify: (_) => verify(() => getMedications(limit: 20, skip: 20)).called(1),
    );

    blocTest<MedicationListCubit, MedicationListState>(
      'keeps existing items and sets loadMoreError when the next page fails',
      setUp: () {
        stubPage(0, Ok(firstPage));
        stubPage(20, const Err(network));
      },
      build: () => MedicationListCubit(getMedications),
      act: (cubit) async {
        await cubit.fetchMedications();
        await cubit.fetchMore();
      },
      skip: 2,
      expect: () => [
        MedicationListLoaded(
          items: firstPage,
          hasReachedMax: false,
          loadMoreError: network,
        ),
      ],
    );

    blocTest<MedicationListCubit, MedicationListState>(
      'sends only one request when called repeatedly while loading',
      setUp: () => stubPage(0, Ok(firstPage)),
      build: () => MedicationListCubit(getMedications),
      act: (cubit) async {
        await cubit.fetchMedications();

        final pending = Completer<Result<List<Medication>>>();
        when(
          () => getMedications(limit: 20, skip: 20),
        ).thenAnswer((_) => pending.future);

        final first = cubit.fetchMore();
        unawaited(cubit.fetchMore());
        unawaited(cubit.fetchMore());
        pending.complete(Ok(secondPage));
        await first;
      },
      verify: (_) => verify(() => getMedications(limit: 20, skip: 20)).called(1),
    );

    blocTest<MedicationListCubit, MedicationListState>(
      'does nothing when all pages are already loaded',
      setUp: () => stubPage(0, Ok(secondPage)),
      build: () => MedicationListCubit(getMedications),
      act: (cubit) async {
        await cubit.fetchMedications();
        await cubit.fetchMore();
      },
      skip: 2,
      expect: () => <MedicationListState>[],
      verify: (_) => verifyNever(() => getMedications(limit: 20, skip: 5)),
    );
  });

  group('retryFetchMore', () {
    blocTest<MedicationListCubit, MedicationListState>(
      'clears loadMoreError then appends the next page',
      setUp: () {
        stubPage(0, Ok(firstPage));
        stubPage(20, const Err(network));
      },
      build: () => MedicationListCubit(getMedications),
      act: (cubit) async {
        await cubit.fetchMedications();
        await cubit.fetchMore();
        stubPage(20, Ok(secondPage));
        await cubit.retryFetchMore();
      },
      skip: 3,
      expect: () => [
        MedicationListLoaded(items: firstPage, hasReachedMax: false),
        MedicationListLoaded(
          items: [...firstPage, ...secondPage],
          hasReachedMax: true,
        ),
      ],
    );
  });
}
