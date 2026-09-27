import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:medication_app/core/error/failure.dart';
import 'package:medication_app/core/utils/result.dart';
import 'package:medication_app/data/datasources/local/favorite_local_datasource.dart';
import 'package:medication_app/data/datasources/remote/medication_remote_datasource.dart';
import 'package:medication_app/data/models/medication_model.dart';
import 'package:medication_app/data/repositories/medication_repository_impl.dart';
import 'package:medication_app/domain/entities/medication.dart';

// Fakes for the data sources so no real HTTP or Hive calls happen.
class MockRemoteDataSource extends Mock implements MedicationRemoteDataSource {}

class MockLocalDataSource extends Mock implements FavoriteLocalDataSource {}

// Builds a DioException that carries the given HTTP status code.
DioException dioErrorWithStatus(int statusCode) {
  final requestOptions = RequestOptions(path: '/drug/label.json');
  return DioException(
    requestOptions: requestOptions,
    response: Response(requestOptions: requestOptions, statusCode: statusCode),
    type: DioExceptionType.badResponse,
  );
}

void main() {
  late MockRemoteDataSource remote;
  late MockLocalDataSource local;
  late MedicationRepositoryImpl repository;

  const model = MedicationModel(
    id: 'abc-123',
    brandName: 'Tylenol',
    genericName: 'ACETAMINOPHEN',
    manufacturer: 'Kenvue',
  );

  // Fresh mocks per test so stubs never leak between tests.
  setUp(() {
    remote = MockRemoteDataSource();
    local = MockLocalDataSource();
    repository = MedicationRepositoryImpl(remote, local);
  });

  // Stubs remote.getMedications (any limit/skip) to throw the given error.
  void stubGetMedicationsThrows(Object error) {
    when(
      () => remote.getMedications(
        limit: any(named: 'limit'),
        skip: any(named: 'skip'),
      ),
    ).thenThrow(error);
  }

  // Calls getMedications and returns the Failure, failing the test if it was Ok.
  Future<Failure> getFailure() async {
    final result = await repository.getMedications(limit: 20, skip: 0);
    return switch (result) {
      Err(:final failure) => failure,
      Ok() => fail('Expected Err but got Ok'),
    };
  }

  group('getMedications', () {
    test('returns Ok with entities mapped from models on success', () async {
      when(
        () => remote.getMedications(limit: 20, skip: 40),
      ).thenAnswer((_) async => [model]);

      final result = await repository.getMedications(limit: 20, skip: 40);

      expect(result, isA<Ok<List<Medication>>>());
      expect((result as Ok<List<Medication>>).value, const [
        Medication(
          id: 'abc-123',
          brandName: 'Tylenol',
          genericName: 'ACETAMINOPHEN',
          manufacturer: 'Kenvue',
        ),
      ]);
      // Pagination params must be forwarded unchanged.
      verify(() => remote.getMedications(limit: 20, skip: 40)).called(1);
    });

    test('returns RateLimitFailure when the API answers 429', () async {
      stubGetMedicationsThrows(dioErrorWithStatus(429));

      expect(await getFailure(), isA<RateLimitFailure>());
    });

    test('returns ServerFailure when the API answers 5xx', () async {
      stubGetMedicationsThrows(dioErrorWithStatus(503));

      expect(await getFailure(), isA<ServerFailure>());
    });

    test('returns NetworkFailure on a connection error', () async {
      stubGetMedicationsThrows(
        DioException.connectionError(
          requestOptions: RequestOptions(path: '/drug/label.json'),
          reason: 'offline',
        ),
      );

      expect(await getFailure(), isA<NetworkFailure>());
    });

    // Not in reference: covers the receiveTimeout fix in _mapException.
    test('returns NetworkFailure when the server is too slow to respond', () async {
      stubGetMedicationsThrows(
        DioException.receiveTimeout(
          timeout: const Duration(seconds: 10),
          requestOptions: RequestOptions(path: '/drug/label.json'),
        ),
      );

      expect(await getFailure(), isA<NetworkFailure>());
    });

    test('returns InvalidDataFailure when parsing fails', () async {
      stubGetMedicationsThrows(const FormatException('bad json'));

      expect(await getFailure(), isA<InvalidDataFailure>());
    });

    test('returns UnknownFailure for any other error', () async {
      stubGetMedicationsThrows(StateError('unexpected'));

      expect(await getFailure(), isA<UnknownFailure>());
    });
  });

  group('watchFavorites', () {
    test('wraps each emitted list of models in Ok with entities', () async {
      when(() => local.watchFavorites()).thenAnswer((_) => Stream.value([model]));

      await expectLater(
        repository.watchFavorites(),
        emits(
          isA<Ok<List<Medication>>>().having((r) => r.value, 'value', [model.toEntity()]),
        ),
      );
    });

    test('turns a storage error into Err instead of throwing', () async {
      when(() => local.watchFavorites()).thenAnswer((_) => Stream.error(StateError('hive')));

      await expectLater(
        repository.watchFavorites(),
        emits(
          isA<Err<List<Medication>>>().having((r) => r.failure, 'failure', isA<UnknownFailure>()),
        ),
      );
    });
  });
}
