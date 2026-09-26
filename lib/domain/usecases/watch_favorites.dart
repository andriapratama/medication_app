import '../../core/utils/result.dart';
import '../entities/medication.dart';
import '../repositories/medication_repository.dart';

class WatchFavorites {
  final MedicationRepository repository;

  const WatchFavorites(this.repository);

  Stream<Result<List<Medication>>> call() {
    return repository.watchFavorites();
  }
}
