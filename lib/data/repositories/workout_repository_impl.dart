import 'package:booklook/data/datasources/hive_local_datasource.dart';
import 'package:booklook/data/models/workout_model.dart';
import 'package:booklook/domain/entities/workout.dart';
import 'package:booklook/domain/repositories/workout_repository.dart';

class WorkoutRepositoryImpl implements WorkoutRepository {
  final HiveLocalDatasource _datasource;
  const WorkoutRepositoryImpl(this._datasource);

  @override
  Future<List<Workout>> getAll() async {
    final list =
        _datasource.workoutsBox.values.map((m) => m.toEntity()).toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  @override
  Future<Workout?> getById(String id) async {
    try {
      return _datasource.workoutsBox.values
          .firstWhere((m) => m.id == id)
          .toEntity();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> add(Workout workout) async {
    final model = WorkoutModel.fromEntity(workout);
    await _datasource.workoutsBox.put(workout.id, model);
  }

  @override
  Future<void> update(Workout workout) async {
    final model = WorkoutModel.fromEntity(workout);
    await _datasource.workoutsBox.put(workout.id, model);
  }

  @override
  Future<void> delete(String id) async {
    await _datasource.workoutsBox.delete(id);
  }
}
