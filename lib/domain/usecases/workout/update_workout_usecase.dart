import 'package:booklook/domain/entities/workout.dart';
import 'package:booklook/domain/repositories/workout_repository.dart';

class UpdateWorkoutUseCase {
  final WorkoutRepository _repository;
  const UpdateWorkoutUseCase(this._repository);

  Future<void> call(Workout workout) => _repository.update(workout);
}
