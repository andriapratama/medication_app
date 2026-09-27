// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedicationModelAdapter extends TypeAdapter<MedicationModel> {
  @override
  final int typeId = 0;

  @override
  MedicationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedicationModel(
      id: fields[0] as String,
      brandName: fields[1] as String?,
      genericName: fields[2] as String?,
      manufacturer: fields[3] as String?,
      purpose: fields[4] as String?,
      indicationsAndUsage: fields[5] as String?,
      dosageAndAdministration: fields[6] as String?,
      warnings: fields[7] as String?,
      activeIngredients: (fields[8] as List).cast<String>(),
      productType: fields[9] as String?,
      inactiveIngredients:
          fields[10] == null ? [] : (fields[10] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, MedicationModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.brandName)
      ..writeByte(2)
      ..write(obj.genericName)
      ..writeByte(3)
      ..write(obj.manufacturer)
      ..writeByte(4)
      ..write(obj.purpose)
      ..writeByte(5)
      ..write(obj.indicationsAndUsage)
      ..writeByte(6)
      ..write(obj.dosageAndAdministration)
      ..writeByte(7)
      ..write(obj.warnings)
      ..writeByte(8)
      ..write(obj.activeIngredients)
      ..writeByte(9)
      ..write(obj.productType)
      ..writeByte(10)
      ..write(obj.inactiveIngredients);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
