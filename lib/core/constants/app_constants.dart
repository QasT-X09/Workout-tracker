enum MuscleGroup {
  chest,
  back,
  legs,
  shoulders,
  arms,
  core,
  cardio,
}

extension MuscleGroupExtension on MuscleGroup {
  String get displayName {
    switch (this) {
      case MuscleGroup.chest:
        return 'Грудь';
      case MuscleGroup.back:
        return 'Спина';
      case MuscleGroup.legs:
        return 'Ноги';
      case MuscleGroup.shoulders:
        return 'Плечи';
      case MuscleGroup.arms:
        return 'Руки';
      case MuscleGroup.core:
        return 'Кор';
      case MuscleGroup.cardio:
        return 'Кардио';
    }
  }
}

class AppConstants {
  static const String exercisesBox = 'exercises';
  static const String workoutsBox = 'workouts';

  static const double cardRadius = 24.0;
  static const double glassOpacity = 0.15;
}
