import '../../core/utils/result.dart';
import '../entities/medication.dart';
import '../entities/medication_detail.dart';

abstract class MedicationRepository {
  Future<Result<List<Medication>>> getMedications({
    required int limit,
    required int skip,
  });

  Future<Result<List<Medication>>> searchMedications({
    required String query,
    required int limit,
    required int skip,
  });

  Future<Result<MedicationDetail>> getMedicationDetail(String id);

  Future<Result<void>> addFavorite(MedicationDetail medication);

  Future<Result<void>> removeFavorite(String id);

  Stream<Result<List<Medication>>> watchFavorites();
}
