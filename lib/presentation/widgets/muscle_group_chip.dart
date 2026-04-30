import 'package:flutter/material.dart';
import 'package:booklook/core/constants/app_constants.dart';

class MuscleGroupChip extends StatelessWidget {
  final MuscleGroup group;
  final bool selected;
  final ValueChanged<bool>? onSelected;

  const MuscleGroupChip({
    super.key,
    required this.group,
    this.selected = false,
    this.onSelected,
  });

  static Color _colorFor(MuscleGroup g) {
    switch (g) {
      case MuscleGroup.chest:
        return const Color(0xFFEF4444);
      case MuscleGroup.back:
        return const Color(0xFF3B82F6);
      case MuscleGroup.legs:
        return const Color(0xFF10B981);
      case MuscleGroup.shoulders:
        return const Color(0xFFF59E0B);
      case MuscleGroup.arms:
        return const Color(0xFF8B5CF6);
      case MuscleGroup.core:
        return const Color(0xFF06B6D4);
      case MuscleGroup.cardio:
        return const Color(0xFFF97316);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(group);
    return FilterChip(
      label: Text(
        group.displayName,
        style: TextStyle(
          color: selected ? Colors.white : color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
      selected: selected,
      onSelected: onSelected,
      backgroundColor: color.withAlpha(26),
      selectedColor: color,
      checkmarkColor: Colors.white,
      side: BorderSide(color: color.withAlpha(128)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    );
  }
}
