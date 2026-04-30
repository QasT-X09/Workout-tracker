import 'package:booklook/domain/entities/workout.dart';

abstract class WorkoutRepository {
  Future<List<Workout>> getAll();
  Future<Workout?> getById(String id);
  Future<void> add(Workout workout);
  Future<void> update(Workout workout);
  Future<void> delete(String id);
}
