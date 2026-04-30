import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:booklook/domain/entities/exercise.dart';
import 'package:booklook/domain/entities/workout.dart';
import 'package:booklook/presentation/providers/exercise_provider.dart';
import 'package:booklook/presentation/providers/workout_provider.dart';
import 'package:booklook/presentation/widgets/glass_card.dart';
import 'package:booklook/presentation/widgets/gradient_scaffold.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  String? _filterExerciseId;

  @override
  Widget build(BuildContext context) {
    final workouts = ref.watch(workoutsProvider);
    final exercises = ref.watch(exercisesProvider);

    final filtered = _filterExerciseId == null
        ? workouts
        : workouts
            .where((w) =>
                w.exercises.any((e) => e.exerciseId == _filterExerciseId))
            .toList();

    return GradientScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('История',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          if (exercises.isNotEmpty)
            PopupMenuButton<String?>(
              icon: Icon(
                Icons.filter_list,
                color: _filterExerciseId != null
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              onSelected: (v) => setState(() => _filterExerciseId = v),
              itemBuilder: (_) => [
                const PopupMenuItem(value: null, child: Text('Все')),
                ...exercises.map(
                  (e) => PopupMenuItem(
                    value: e.id,
                    child: Text(e.name),
                  ),
                ),
              ],
            ),
        ],
      ),
      body: SafeArea(
        child: filtered.isEmpty
            ? Center(
                child: Text(
                  'История пуста.\nСоздайте тренировку!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        Theme.of(context).colorScheme.onSurface.withAlpha(153),
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filtered.length,
                itemBuilder: (_, i) => _HistoryCard(
                  workout: filtered[i],
                  exercises: exercises,
                ),
              ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final Workout workout;
  final List<Exercise> exercises;

  const _HistoryCard({required this.workout, required this.exercises});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final names = workout.exercises
        .map((we) {
          try {
            return exercises.firstWhere((e) => e.id == we.exerciseId).name;
          } catch (_) {
            return '?';
          }
        })
        .take(3)
        .join(', ');

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => context.push('/workout/${workout.id}'),
        child: GlassCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: scheme.primary.withAlpha(26),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      workout.date.day.toString(),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: scheme.primary),
                    ),
                    Text(
                      _monthAbbr(workout.date.month),
                      style: TextStyle(
                          fontSize: 11, color: scheme.primary.withAlpha(179)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      names.isEmpty ? 'Тренировка' : names,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${workout.exercises.length} упр. · ${workout.totalSets} подходов',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${workout.totalVolume.toInt()}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: scheme.primary),
                  ),
                  Text('кг·повт.',
                      style: TextStyle(
                          fontSize: 11,
                          color: scheme.onSurface.withAlpha(128))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _monthAbbr(int month) {
    const months = [
      'янв',
      'фев',
      'мар',
      'апр',
      'май',
      'июн',
      'июл',
      'авг',
      'сен',
      'окт',
      'ноя',
      'дек',
    ];
    return months[month - 1];
  }
}
