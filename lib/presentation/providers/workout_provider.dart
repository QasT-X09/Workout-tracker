import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:booklook/domain/entities/workout.dart';
import 'package:booklook/domain/entities/workout_exercise.dart';
import 'package:booklook/domain/usecases/workout/add_workout_usecase.dart';
import 'package:booklook/domain/usecases/workout/delete_workout_usecase.dart';
import 'package:booklook/domain/usecases/workout/get_workouts_usecase.dart';
import 'package:booklook/domain/usecases/workout/update_workout_usecase.dart';
import 'package:booklook/presentation/providers/repository_providers.dart';

final workoutsProvider =
    NotifierProvider<WorkoutsNotifier, List<Workout>>(WorkoutsNotifier.new);

class WorkoutsNotifier extends Notifier<List<Workout>> {
  static const _uuid = Uuid();

  late AddWorkoutUseCase _add;
  late GetWorkoutsUseCase _getAll;
  late UpdateWorkoutUseCase _update;
  late DeleteWorkoutUseCase _delete;

  @override
  List<Workout> build() {
    final repo = ref.watch(workoutRepositoryProvider);
    _add = AddWorkoutUseCase(repo);
    _getAll = GetWorkoutsUseCase(repo);
    _update = UpdateWorkoutUseCase(repo);
    _delete = DeleteWorkoutUseCase(repo);
    _load();
    return [];
  }

  Future<void> _load() async {
    final list = await _getAll();
    state = list;
  }

  Future<String> addWorkout(List<WorkoutExercise> exercises) async {
    final workout = Workout(
      id: _uuid.v4(),
      date: DateTime.now(),
      exercises: exercises,
    );
    await _add(workout);
    state = [workout, ...state];
    return workout.id;
  }

  Future<void> updateWorkout(Workout workout) async {
    await _update(workout);
    state = state.map((w) => w.id == workout.id ? workout : w).toList();
  }

  Future<void> deleteWorkout(String id) async {
    await _delete(id);
    state = state.where((w) => w.id != id).toList();
  }

  Workout? getById(String id) {
    try {
      return state.firstWhere((w) => w.id == id);
    } catch (_) {
      return null;
    }
  }
}
