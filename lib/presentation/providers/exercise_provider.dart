import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:booklook/domain/entities/exercise.dart';
import 'package:booklook/domain/usecases/exercise/add_exercise_usecase.dart';
import 'package:booklook/domain/usecases/exercise/delete_exercise_usecase.dart';
import 'package:booklook/domain/usecases/exercise/get_exercises_usecase.dart';
import 'package:booklook/presentation/providers/repository_providers.dart';

final exercisesProvider =
    NotifierProvider<ExercisesNotifier, List<Exercise>>(ExercisesNotifier.new);

class ExercisesNotifier extends Notifier<List<Exercise>> {
  static const _uuid = Uuid();

  late AddExerciseUseCase _add;
  late GetExercisesUseCase _getAll;
  late DeleteExerciseUseCase _delete;

  @override
  List<Exercise> build() {
    final repo = ref.watch(exerciseRepositoryProvider);
    _add = AddExerciseUseCase(repo);
    _getAll = GetExercisesUseCase(repo);
    _delete = DeleteExerciseUseCase(repo);
    _load();
    return [];
  }

  Future<void> _load() async {
    final list = await _getAll();
    state = list;
  }

  Future<void> addExercise(String name, muscleGroup) async {
    final exercise = Exercise(
      id: _uuid.v4(),
      name: name,
      muscleGroup: muscleGroup,
    );
    await _add(exercise);
    state = [...state, exercise];
  }

  Future<void> deleteExercise(String id) async {
    await _delete(id);
    state = state.where((e) => e.id != id).toList();
  }
}
