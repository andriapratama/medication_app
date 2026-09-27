import 'package:hive/hive.dart';

import '../../models/medication_model.dart';

abstract class FavoriteLocalDataSource {
  Future<bool> isFavorite(String id);
  Future<void> addFavorite(MedicationModel medication);
  Future<void> removeFavorite(String id);
  Stream<List<MedicationModel>> watchFavorites();
}

class FavoriteLocalDataSourceImpl implements FavoriteLocalDataSource {
  static const String boxName = 'favorite_box';

  final Box<MedicationModel> box;

  FavoriteLocalDataSourceImpl(this.box);

  @override
  Future<bool> isFavorite(String id) async {
    return box.containsKey(id);
  }

  @override
  Future<void> addFavorite(MedicationModel medication) async {
    await box.put(medication.id, medication);
  }

  @override
  Future<void> removeFavorite(String id) async {
    await box.delete(id);
  }

  @override
  Stream<List<MedicationModel>> watchFavorites() async* {
    yield box.values.toList();
    await for (final _ in box.watch()) {
      yield box.values.toList();
    }
  }
}
