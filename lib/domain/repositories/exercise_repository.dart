import 'package:booklook/domain/entities/exercise.dart';

abstract class ExerciseRepository {
  Future<List<Exercise>> getAll();
  Future<Exercise?> getById(String id);
  Future<void> add(Exercise exercise);
  Future<void> update(Exercise exercise);
  Future<void> delete(String id);
}
