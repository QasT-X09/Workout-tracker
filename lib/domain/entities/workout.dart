import 'package:booklook/domain/entities/workout_exercise.dart';

class Workout {
  final String id;
  final DateTime date;
  final List<WorkoutExercise> exercises;

  const Workout({
    required this.id,
    required this.date,
    required this.exercises,
  });

  Workout copyWith({
    String? id,
    DateTime? date,
    List<WorkoutExercise>? exercises,
  }) {
    return Workout(
      id: id ?? this.id,
      date: date ?? this.date,
      exercises: exercises ?? this.exercises,
    );
  }

  double get totalVolume =>
      exercises.fold(0.0, (sum, e) => sum + e.totalVolume);

  int get totalSets => exercises.fold(0, (sum, e) => sum + e.sets.length);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Workout && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
