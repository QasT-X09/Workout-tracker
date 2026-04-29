import 'package:booklook/domain/repositories/exercise_repository.dart';

class DeleteExerciseUseCase {
  final ExerciseRepository _repository;
  const DeleteExerciseUseCase(this._repository);

  Future<void> call(String id) => _repository.delete(id);
}
