import '../../core/utils/result.dart';
import '../entities/medication_detail.dart';
import '../repositories/medication_repository.dart';

class AddFavorite {
  final MedicationRepository repository;

  const AddFavorite(this.repository);

  Future<Result<void>> call(MedicationDetail medication) {
    return repository.addFavorite(medication);
  }
}
