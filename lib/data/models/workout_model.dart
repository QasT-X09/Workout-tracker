import 'package:hive_flutter/hive_flutter.dart';
import 'package:booklook/data/models/workout_exercise_model.dart';
import 'package:booklook/domain/entities/workout.dart';

part 'workout_model.g.dart';

@HiveType(typeId: 3)
class WorkoutModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late DateTime date;

  @HiveField(2)
  late List<WorkoutExerciseModel> exercises;

  WorkoutModel();

  factory WorkoutModel.fromEntity(Workout w) => WorkoutModel()
    ..id = w.id
    ..date = w.date
    ..exercises = w.exercises.map(WorkoutExerciseModel.fromEntity).toList();

  Workout toEntity() => Workout(
        id: id,
        date: date,
        exercises: exercises.map((e) => e.toEntity()).toList(),
      );
}
