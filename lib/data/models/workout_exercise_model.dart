import 'package:hive_flutter/hive_flutter.dart';
import 'package:booklook/data/models/set_data_model.dart';
import 'package:booklook/domain/entities/workout_exercise.dart';

part 'workout_exercise_model.g.dart';

@HiveType(typeId: 2)
class WorkoutExerciseModel extends HiveObject {
  @HiveField(0)
  late String exerciseId;

  @HiveField(1)
  late List<SetDataModel> sets;

  WorkoutExerciseModel();

  factory WorkoutExerciseModel.fromEntity(WorkoutExercise we) =>
      WorkoutExerciseModel()
        ..exerciseId = we.exerciseId
        ..sets = we.sets.map(SetDataModel.fromEntity).toList();

  WorkoutExercise toEntity() => WorkoutExercise(
        exerciseId: exerciseId,
        sets: sets.map((s) => s.toEntity()).toList(),
      );
}
