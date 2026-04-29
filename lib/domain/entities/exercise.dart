import 'package:booklook/core/constants/app_constants.dart';

class Exercise {
  final String id;
  final String name;
  final MuscleGroup muscleGroup;

  const Exercise({
    required this.id,
    required this.name,
    required this.muscleGroup,
  });

  Exercise copyWith({
    String? id,
    String? name,
    MuscleGroup? muscleGroup,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      muscleGroup: muscleGroup ?? this.muscleGroup,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Exercise && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
