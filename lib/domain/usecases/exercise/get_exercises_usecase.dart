import 'package:booklook/domain/entities/exercise.dart';
import 'package:booklook/domain/repositories/exercise_repository.dart';

class GetExercisesUseCase {
  final ExerciseRepository _repository;
  const GetExercisesUseCase(this._repository);

  Future<List<Exercise>> call() => _repository.getAll();
}
