import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:booklook/core/constants/app_constants.dart';
import 'package:booklook/core/router/app_router.dart';
import 'package:booklook/core/router/router_notifier.dart';
import 'package:booklook/core/theme/app_theme.dart';
import 'package:booklook/data/datasources/auth_local_datasource.dart';
import 'package:booklook/data/models/exercise_model.dart';
import 'package:booklook/data/models/set_data_model.dart';
import 'package:booklook/data/models/workout_exercise_model.dart';
import 'package:booklook/data/models/workout_model.dart';
import 'package:booklook/presentation/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(ExerciseModelAdapter());
  Hive.registerAdapter(SetDataModelAdapter());
  Hive.registerAdapter(WorkoutExerciseModelAdapter());
  Hive.registerAdapter(WorkoutModelAdapter());

  await Hive.openBox<ExerciseModel>(AppConstants.exercisesBox);
  await Hive.openBox<WorkoutModel>(AppConstants.workoutsBox);

  // Restore auth state before rendering the first frame
  final isLoggedIn = await AuthLocalDatasource().isLoggedIn();
  routerNotifier.setLoggedIn(isLoggedIn);

  runApp(const ProviderScope(child: WorkoutTrackerApp()));
}

class WorkoutTrackerApp extends ConsumerWidget {
  const WorkoutTrackerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    return MaterialApp.router(
      title: 'Workout Tracker 2026',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
