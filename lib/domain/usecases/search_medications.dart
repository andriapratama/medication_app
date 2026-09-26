import '../../core/utils/result.dart';
import '../entities/medication.dart';
import '../repositories/medication_repository.dart';

class SearchMedications {
  final MedicationRepository repository;

  const SearchMedications(this.repository);

  Future<Result<List<Medication>>> call({
    required String query,
    required int limit,
    required int skip,
  }) {
    return repository.searchMedications(query: query, limit: limit, skip: skip);
  }
}
