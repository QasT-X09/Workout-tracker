import 'package:booklook/domain/repositories/workout_repository.dart';

class DeleteWorkoutUseCase {
  final WorkoutRepository _repository;
  const DeleteWorkoutUseCase(this._repository);

  Future<void> call(String id) => _repository.delete(id);
}
