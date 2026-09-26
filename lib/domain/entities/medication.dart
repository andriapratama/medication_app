import 'package:equatable/equatable.dart';

class Medication extends Equatable {
  final String id;
  final String? brandName;
  final String? genericName;
  final String? manufacturer;

  const Medication({
    required this.id,
    this.brandName,
    this.genericName,
    this.manufacturer,
  });

  @override
  List<Object?> get props => [id, brandName, genericName, manufacturer];
}
