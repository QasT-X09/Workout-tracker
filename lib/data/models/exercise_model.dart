import 'package:hive_flutter/hive_flutter.dart';
import 'package:booklook/core/constants/app_constants.dart';
import 'package:booklook/domain/entities/exercise.dart';

part 'exercise_model.g.dart';

@HiveType(typeId: 0)
class ExerciseModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late int muscleGroupIndex;

  ExerciseModel();

  factory ExerciseModel.fromEntity(Exercise e) => ExerciseModel()
    ..id = e.id
    ..name = e.name
    ..muscleGroupIndex = e.muscleGroup.index;

  Exercise toEntity() => Exercise(
        id: id,
        name: name,
        muscleGroup: MuscleGroup.values[muscleGroupIndex],
      );
}
