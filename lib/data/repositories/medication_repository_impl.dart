import 'dart:async';

import 'package:dio/dio.dart';

import '../../core/constants/api_constants.dart';
import '../../core/error/failure.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/medication.dart';
import '../../domain/entities/medication_detail.dart';
import '../../domain/repositories/medication_repository.dart';
import '../datasources/local/favorite_local_datasource.dart';
import '../datasources/remote/medication_remote_datasource.dart';
import '../models/medication_model.dart';

class MedicationRepositoryImpl implements MedicationRepository {
  final MedicationRemoteDataSource remoteDataSource;
  final FavoriteLocalDataSource localDataSource;

  MedicationRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Result<List<Medication>>> getMedications({
    required int limit,
    required int skip,
  }) async {
    try {
      final models = await remoteDataSource.getMedications(
        limit: limit,
        skip: skip,
      );
      return Ok(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Err(_mapException(e));
    }
  }

  @override
  Future<Result<List<Medication>>> searchMedications({
    required String query,
    required int limit,
    required int skip,
  }) async {
    try {
      final models = await remoteDataSource.searchMedications(
        query: query,
        limit: limit,
        skip: skip,
      );
      return Ok(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Err(_mapException(e));
    }
  }

  @override
  Future<Result<MedicationDetail>> getMedicationDetail(String id) async {
    try {
      final model = await remoteDataSource.getMedicationById(id);
      final isFavorite = await localDataSource.isFavorite(model.id);
      return Ok(model.toDetailEntity(isFavorite: isFavorite));
    } catch (e) {
      return Err(_mapException(e));
    }
  }

  @override
  Future<Result<void>> addFavorite(MedicationDetail medication) async {
    try {
      await localDataSource.addFavorite(
        MedicationModel.fromDetailEntity(medication),
      );
      return const Ok(null);
    } catch (e) {
      return Err(_mapException(e));
    }
  }

  @override
  Future<Result<void>> removeFavorite(String id) async {
    try {
      await localDataSource.removeFavorite(id);
      return const Ok(null);
    } catch (e) {
      return Err(_mapException(e));
    }
  }

  @override
  Stream<Result<List<Medication>>> watchFavorites() {
    return localDataSource.watchFavorites().transform(
      StreamTransformer<
        List<MedicationModel>,
        Result<List<Medication>>
      >.fromHandlers(
        handleData: (models, sink) =>
            sink.add(Ok(models.map((m) => m.toEntity()).toList())),
        handleError: (error, _, sink) => sink.add(Err(_mapException(error))),
      ),
    );
  }

  Failure _mapException(Object e) {
    if (e is DioException) {
      final statusCode = e.response?.statusCode;
      if (statusCode == ApiConstants.rateLimitStatusCode) {
        return const RateLimitFailure(
          'Too many requests, please try again later.',
        );
      }

      if (statusCode != null && statusCode >= 500) {
        return ServerFailure('Server error ($statusCode)');
      }

      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return const NetworkFailure('No internet connection.');
      }

      return UnknownFailure(e.message ?? 'Unknown network error.');
    }

    if (e is FormatException) {
      return InvalidDataFailure(e.message);
    }

    return UnknownFailure(e.toString());
  }
}
