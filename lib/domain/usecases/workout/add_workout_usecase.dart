import 'package:booklook/domain/entities/workout.dart';
import 'package:booklook/domain/repositories/workout_repository.dart';

class AddWorkoutUseCase {
  final WorkoutRepository _repository;
  const AddWorkoutUseCase(this._repository);

  Future<void> call(Workout workout) => _repository.add(workout);
}
