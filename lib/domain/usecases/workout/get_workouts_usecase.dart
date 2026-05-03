import 'package:booklook/domain/entities/workout.dart';
import 'package:booklook/domain/repositories/workout_repository.dart';

class GetWorkoutsUseCase {
  final WorkoutRepository _repository;
  const GetWorkoutsUseCase(this._repository);

  Future<List<Workout>> call() => _repository.getAll();
}
