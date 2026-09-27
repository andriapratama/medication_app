import 'package:equatable/equatable.dart';

import '../../../core/error/failure.dart';
import '../../../domain/entities/medication.dart';

sealed class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Medication> items;

  const FavoritesLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class FavoritesEmpty extends FavoritesState {}

class FavoritesError extends FavoritesState {
  final Failure failure;

  const FavoritesError(this.failure);

  @override
  List<Object?> get props => [failure];
}
