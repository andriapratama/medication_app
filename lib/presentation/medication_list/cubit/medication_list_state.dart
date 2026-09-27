import 'package:equatable/equatable.dart';

import '../../../core/error/failure.dart';
import '../../../domain/entities/medication.dart';

sealed class MedicationListState extends Equatable {
  const MedicationListState();

  @override
  List<Object?> get props => [];
}

class MedicationListInitial extends MedicationListState {}

class MedicationListLoading extends MedicationListState {}

class MedicationListLoaded extends MedicationListState {
  final List<Medication> items;
  final bool hasReachedMax;
  final Failure? loadMoreError;

  const MedicationListLoaded({
    required this.items,
    required this.hasReachedMax,
    this.loadMoreError,
  });

  @override
  List<Object?> get props => [items, hasReachedMax, loadMoreError];
}

class MedicationListEmpty extends MedicationListState {}

class MedicationListError extends MedicationListState {
  final Failure failure;

  const MedicationListError(this.failure);

  @override
  List<Object?> get props => [failure];
}
