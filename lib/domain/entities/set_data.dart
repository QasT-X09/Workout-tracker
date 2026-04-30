class SetData {
  final double weight;
  final int reps;

  const SetData({
    required this.weight,
    required this.reps,
  });

  SetData copyWith({double? weight, int? reps}) {
    return SetData(
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
    );
  }

  double get volume => weight * reps;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SetData && other.weight == weight && other.reps == reps;

  @override
  int get hashCode => Object.hash(weight, reps);
}
