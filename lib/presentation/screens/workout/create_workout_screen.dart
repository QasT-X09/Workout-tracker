import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:booklook/domain/entities/exercise.dart';
import 'package:booklook/domain/entities/set_data.dart';
import 'package:booklook/domain/entities/workout_exercise.dart';
import 'package:booklook/presentation/providers/exercise_provider.dart';
import 'package:booklook/presentation/providers/workout_provider.dart';
import 'package:booklook/presentation/widgets/glass_card.dart';
import 'package:booklook/presentation/widgets/gradient_scaffold.dart';
import 'package:booklook/presentation/widgets/muscle_group_chip.dart';
import 'package:booklook/presentation/widgets/set_row_widget.dart';

class _ExerciseDraft {
  final Exercise exercise;
  List<SetData> sets;

  _ExerciseDraft({required this.exercise, required this.sets});
}

class CreateWorkoutScreen extends ConsumerStatefulWidget {
  const CreateWorkoutScreen({super.key});

  @override
  ConsumerState<CreateWorkoutScreen> createState() =>
      _CreateWorkoutScreenState();
}

class _CreateWorkoutScreenState extends ConsumerState<CreateWorkoutScreen> {
  final List<_ExerciseDraft> _drafts = [];
  bool _saving = false;

  Future<void> _addExercise() async {
    final all = ref.read(exercisesProvider);
    if (all.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Сначала добавьте упражнения в базу!'),
        ),
      );
      return;
    }

    final selected = await showModalBottomSheet<Exercise>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _ExercisePicker(exercises: all),
    );

    if (selected != null) {
      setState(() {
        _drafts.add(_ExerciseDraft(
          exercise: selected,
          sets: [const SetData(weight: 0, reps: 0)],
        ));
      });
    }
  }

  Future<void> _save() async {
    if (_drafts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Добавьте хотя бы одно упражнение')),
      );
      return;
    }

    setState(() => _saving = true);

    final workoutExercises = _drafts
        .map((d) => WorkoutExercise(
              exerciseId: d.exercise.id,
              sets: d.sets.where((s) => s.reps > 0 || s.weight > 0).toList(),
            ))
        .where((we) => we.sets.isNotEmpty)
        .toList();

    if (workoutExercises.isEmpty) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните хотя бы один подход')),
      );
      return;
    }

    final id =
        await ref.read(workoutsProvider.notifier).addWorkout(workoutExercises);

    if (mounted) {
      setState(() => _saving = false);
      context.push('/workout/$id');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Новая тренировка',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Сохранить',
                    style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _drafts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.fitness_center,
                              size: 64,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withAlpha(102)),
                          const SizedBox(height: 16),
                          Text(
                            'Добавьте упражнения',
                            style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withAlpha(153)),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _drafts.length,
                      itemBuilder: (_, i) => _DraftCard(
                        draft: _drafts[i],
                        onAddSet: () => setState(() {
                          _drafts[i]
                              .sets
                              .add(const SetData(weight: 0, reps: 0));
                        }),
                        onRemoveSet: (si) => setState(() {
                          if (_drafts[i].sets.length > 1) {
                            _drafts[i].sets.removeAt(si);
                          }
                        }),
                        onSetChanged: (si, s) =>
                            setState(() => _drafts[i].sets[si] = s),
                        onRemoveExercise: () =>
                            setState(() => _drafts.removeAt(i)),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: _addExercise,
                  icon: const Icon(Icons.add),
                  label: const Text('Добавить упражнение'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DraftCard extends StatelessWidget {
  final _ExerciseDraft draft;
  final VoidCallback onAddSet;
  final void Function(int) onRemoveSet;
  final void Function(int, SetData) onSetChanged;
  final VoidCallback onRemoveExercise;

  const _DraftCard({
    required this.draft,
    required this.onAddSet,
    required this.onRemoveSet,
    required this.onSetChanged,
    required this.onRemoveExercise,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                MuscleGroupChip(group: draft.exercise.muscleGroup),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    draft.exercise.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: scheme.error, size: 20),
                  onPressed: onRemoveExercise,
                ),
              ],
            ),
            const Divider(height: 16),
            ...draft.sets.asMap().entries.map(
                  (e) => SetRowWidget(
                    key: ValueKey('set-${draft.exercise.id}-${e.key}'),
                    index: e.key + 1,
                    initial: e.value,
                    onChanged: (s) => onSetChanged(e.key, s),
                    onDelete: () => onRemoveSet(e.key),
                  ),
                ),
            const SizedBox(height: 4),
            TextButton.icon(
              onPressed: onAddSet,
              icon: const Icon(Icons.add, size: 16),
              label:
                  const Text('Добавить подход', style: TextStyle(fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExercisePicker extends StatelessWidget {
  final List<Exercise> exercises;
  const _ExercisePicker({required this.exercises});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (_, ctrl) => GlassCard(
        borderRadius: 28,
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(77),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            const Text('Выберите упражнение',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                controller: ctrl,
                itemCount: exercises.length,
                itemBuilder: (_, i) {
                  final ex = exercises[i];
                  return ListTile(
                    leading: MuscleGroupChip(group: ex.muscleGroup),
                    title: Text(ex.name),
                    onTap: () => Navigator.pop(context, ex),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
