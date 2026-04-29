import 'package:hive_flutter/hive_flutter.dart';
import 'package:booklook/core/constants/app_constants.dart';
import 'package:booklook/data/models/exercise_model.dart';
import 'package:booklook/data/models/workout_model.dart';

class HiveLocalDatasource {
  Box<ExerciseModel> get exercisesBox =>
      Hive.box<ExerciseModel>(AppConstants.exercisesBox);

  Box<WorkoutModel> get workoutsBox =>
      Hive.box<WorkoutModel>(AppConstants.workoutsBox);
}
