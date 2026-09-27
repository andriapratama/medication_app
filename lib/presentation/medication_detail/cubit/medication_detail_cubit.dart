import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/result.dart';
import '../../../domain/usecases/add_favorite.dart';
import '../../../domain/usecases/get_medication_detail.dart';
import '../../../domain/usecases/remove_favorite.dart';
import 'medication_detail_state.dart';

class MedicationDetailCubit extends Cubit<MedicationDetailState> {
  final GetMedicationDetail getMedicationDetail;
  final AddFavorite addFavorite;
  final RemoveFavorite removeFavorite;

  bool _isTogglingFavorite = false;

  MedicationDetailCubit({
    required this.getMedicationDetail,
    required this.addFavorite,
    required this.removeFavorite,
  }) : super(MedicationDetailInitial());

  Future<void> fetchDetail(String id) async {
    emit(MedicationDetailLoading());

    final result = await getMedicationDetail(id);
    if (isClosed) return;

    switch (result) {
      case Ok(value: final detail):
        emit(MedicationDetailLoaded(detail));
      case Err(failure: final failure):
        emit(MedicationDetailError(failure));
    }
  }

  Future<void> toggleFavorite() async {
    final currentState = state;
    if (currentState is! MedicationDetailLoaded || _isTogglingFavorite) return;

    _isTogglingFavorite = true;
    final original = currentState.detail;
    final updated = original.copyWith(isFavorite: !original.isFavorite);
    emit(MedicationDetailLoaded(updated));

    final result = original.isFavorite
        ? await removeFavorite(original.id)
        : await addFavorite(updated);
    _isTogglingFavorite = false;
    if (isClosed) return;

    if (result is Err) {
      emit(MedicationDetailLoaded(original));
    }
  }
}
