import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:booklook/data/datasources/hive_local_datasource.dart';
import 'package:booklook/data/repositories/exercise_repository_impl.dart';
import 'package:booklook/data/repositories/workout_repository_impl.dart';
import 'package:booklook/domain/repositories/exercise_repository.dart';
import 'package:booklook/domain/repositories/workout_repository.dart';

final hiveLocalDatasourceProvider = Provider<HiveLocalDatasource>(
  (_) => HiveLocalDatasource(),
);

final exerciseRepositoryProvider = Provider<ExerciseRepository>(
  (ref) => ExerciseRepositoryImpl(ref.watch(hiveLocalDatasourceProvider)),
);

final workoutRepositoryProvider = Provider<WorkoutRepository>(
  (ref) => WorkoutRepositoryImpl(ref.watch(hiveLocalDatasourceProvider)),
);
