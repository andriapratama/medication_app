import 'package:equatable/equatable.dart';

enum MedicationType { otc, prescription }

class MedicationDetail extends Equatable {
  final String id;
  final String? brandName;
  final String? genericName;
  final String? manufacturer;
  final MedicationType? type;
  final String? purpose;
  final String? indicationsAddUsage;
  final String? dosageAndAdministration;
  final String? warnings;
  final List<String> activeIngredients;
  final List<String> inactiveIngredients;
  final bool isFavorite;

  const MedicationDetail({
    required this.id,
    this.brandName,
    this.genericName,
    this.manufacturer,
    this.type,
    this.purpose,
    this.indicationsAddUsage,
    this.dosageAndAdministration,
    this.warnings,
    this.activeIngredients = const [],
    this.inactiveIngredients = const [],
    this.isFavorite = false,
  });

  MedicationDetail copyWith({bool? isFavorite}) {
    return MedicationDetail(
      id: id,
      brandName: brandName,
      genericName: genericName,
      manufacturer: manufacturer,
      type: type,
      purpose: purpose,
      indicationsAddUsage: indicationsAddUsage,
      dosageAndAdministration: dosageAndAdministration,
      warnings: warnings,
      activeIngredients: activeIngredients,
      inactiveIngredients: inactiveIngredients,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
    id,
    brandName,
    genericName,
    manufacturer,
    type,
    purpose,
    indicationsAddUsage,
    dosageAndAdministration,
    warnings,
    activeIngredients,
    inactiveIngredients,
    isFavorite,
  ];
}
