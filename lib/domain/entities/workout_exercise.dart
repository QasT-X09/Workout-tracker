import 'package:booklook/domain/entities/set_data.dart';

class WorkoutExercise {
  final String exerciseId;
  final List<SetData> sets;

  const WorkoutExercise({
    required this.exerciseId,
    required this.sets,
  });

  WorkoutExercise copyWith({
    String? exerciseId,
    List<SetData>? sets,
  }) {
    return WorkoutExercise(
      exerciseId: exerciseId ?? this.exerciseId,
      sets: sets ?? this.sets,
    );
  }

  double get totalVolume => sets.fold(0.0, (sum, s) => sum + s.volume);

  double get maxWeight => sets.isEmpty
      ? 0.0
      : sets.map((s) => s.weight).reduce((a, b) => a > b ? a : b);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutExercise && other.exerciseId == exerciseId;

  @override
  int get hashCode => exerciseId.hashCode;
}
