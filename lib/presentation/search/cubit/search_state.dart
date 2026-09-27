import 'package:equatable/equatable.dart';

import '../../../core/error/failure.dart';
import '../../../domain/entities/medication.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Medication> items;

  const SearchLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class SearchEmpty extends SearchState {}

class SearchError extends SearchState {
  final Failure failure;

  const SearchError(this.failure);

  @override
  List<Object?> get props => [failure];
}
