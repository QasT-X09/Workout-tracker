import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:booklook/core/utils/date_utils.dart';
import 'package:booklook/domain/entities/exercise.dart';
import 'package:booklook/domain/entities/workout.dart';
import 'package:booklook/presentation/providers/exercise_provider.dart';
import 'package:booklook/presentation/providers/workout_provider.dart';
import 'package:booklook/presentation/widgets/glass_card.dart';
import 'package:booklook/presentation/widgets/gradient_scaffold.dart';
import 'package:booklook/presentation/widgets/muscle_group_chip.dart';

class WorkoutDetailScreen extends ConsumerWidget {
  final String workoutId;
  const WorkoutDetailScreen({super.key, required this.workoutId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workouts = ref.watch(workoutsProvider);
    final workout = workouts.where((w) => w.id == workoutId).isEmpty
        ? null
        : workouts.firstWhere((w) => w.id == workoutId);
    final exercises = ref.watch(exercisesProvider);

    if (workout == null) {
      return GradientScaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Тренировка'),
        ),
        body: const Center(child: Text('Тренировка не найдена')),
      );
    }

    return GradientScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(AppDateUtils.formatDate(workout.date),
            style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            color: Theme.of(context).colorScheme.error,
            onPressed: () => _confirmDelete(context, ref, workout),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SummaryRow(workout: workout),
              const SizedBox(height: 16),
              ...workout.exercises.map((we) {
                final ex = _findExercise(exercises, we.exerciseId);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (ex != null)
                              MuscleGroupChip(group: ex.muscleGroup),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                ex?.name ?? we.exerciseId,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            Text(
                              'Макс: ${we.maxWeight} кг',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 16),
                        ...we.sets.asMap().entries.map(
                              (e) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 28,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withAlpha(51),
                                      ),
                                      child: Text(
                                        '${e.key + 1}',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      '${e.value.weight} кг',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 8),
                                    Text('×',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withAlpha(128))),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${e.value.reps} повт.',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '${e.value.volume.toInt()} кг·повт.',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withAlpha(128)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Exercise? _findExercise(List<Exercise> all, String id) {
    try {
      return all.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, Workout workout) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Удалить тренировку?'),
        content: Text(
            'Тренировка от ${AppDateUtils.formatDate(workout.date)} будет удалена.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Отмена')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      await ref.read(workoutsProvider.notifier).deleteWorkout(workout.id);
      if (context.mounted) context.go('/history');
    }
  }
}

class _SummaryRow extends StatelessWidget {
  final Workout workout;
  const _SummaryRow({required this.workout});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        _StatBox(
            label: 'Упражнений',
            value: '${workout.exercises.length}',
            color: scheme.primary),
        const SizedBox(width: 12),
        _StatBox(
            label: 'Подходов',
            value: '${workout.totalSets}',
            color: scheme.secondary),
        const SizedBox(width: 12),
        _StatBox(
            label: 'Объём',
            value: '${workout.totalVolume.toInt()}',
            color: scheme.tertiary),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatBox(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(label,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
