import '../../core/utils/result.dart';
import '../entities/medication_detail.dart';
import '../repositories/medication_repository.dart';

class GetMedicationDetail {
  final MedicationRepository repository;

  const GetMedicationDetail(this.repository);

  Future<Result<MedicationDetail>> call(String id) {
    return repository.getMedicationDetail(id);
  }
}
