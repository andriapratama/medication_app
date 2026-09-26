import 'package:medication_app/core/utils/result.dart';
import 'package:medication_app/domain/repositories/medication_repository.dart';

class RemoveFavorite {
  final MedicationRepository repository;

  const RemoveFavorite(this.repository);

  Future<Result<void>> call(String id) {
    return repository.removeFavorite(id);
  }
}
