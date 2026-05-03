import 'package:booklook/domain/entities/exercise.dart';
import 'package:booklook/domain/repositories/exercise_repository.dart';

class AddExerciseUseCase {
  final ExerciseRepository _repository;
  const AddExerciseUseCase(this._repository);

  Future<void> call(Exercise exercise) => _repository.add(exercise);
}
