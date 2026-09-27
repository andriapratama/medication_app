import 'package:equatable/equatable.dart';

import '../../../core/error/failure.dart';
import '../../../domain/entities/medication_detail.dart';

sealed class MedicationDetailState extends Equatable {
  const MedicationDetailState();

  @override
  List<Object?> get props => [];
}

class MedicationDetailInitial extends MedicationDetailState {}

class MedicationDetailLoading extends MedicationDetailState {}

class MedicationDetailLoaded extends MedicationDetailState {
  final MedicationDetail detail;

  const MedicationDetailLoaded(this.detail);

  @override
  List<Object?> get props => [detail];
}

class MedicationDetailError extends MedicationDetailState {
  final Failure failure;

  const MedicationDetailError(this.failure);

  @override
  List<Object?> get props => [failure];
}
