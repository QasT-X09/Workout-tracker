import 'package:booklook/data/datasources/hive_local_datasource.dart';
import 'package:booklook/data/models/exercise_model.dart';
import 'package:booklook/domain/entities/exercise.dart';
import 'package:booklook/domain/repositories/exercise_repository.dart';

class ExerciseRepositoryImpl implements ExerciseRepository {
  final HiveLocalDatasource _datasource;
  const ExerciseRepositoryImpl(this._datasource);

  @override
  Future<List<Exercise>> getAll() async {
    return _datasource.exercisesBox.values.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Exercise?> getById(String id) async {
    try {
      return _datasource.exercisesBox.values
          .firstWhere((m) => m.id == id)
          .toEntity();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> add(Exercise exercise) async {
    final model = ExerciseModel.fromEntity(exercise);
    await _datasource.exercisesBox.put(exercise.id, model);
  }

  @override
  Future<void> update(Exercise exercise) async {
    final model = ExerciseModel.fromEntity(exercise);
    await _datasource.exercisesBox.put(exercise.id, model);
  }

  @override
  Future<void> delete(String id) async {
    await _datasource.exercisesBox.delete(id);
  }
}
