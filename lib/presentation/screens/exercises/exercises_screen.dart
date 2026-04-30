import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:booklook/core/constants/app_constants.dart';
import 'package:booklook/domain/entities/exercise.dart';
import 'package:booklook/presentation/providers/exercise_provider.dart';
import 'package:booklook/presentation/widgets/glass_card.dart';
import 'package:booklook/presentation/widgets/gradient_scaffold.dart';
import 'package:booklook/presentation/widgets/muscle_group_chip.dart';

class ExercisesScreen extends ConsumerStatefulWidget {
  const ExercisesScreen({super.key});

  @override
  ConsumerState<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends ConsumerState<ExercisesScreen> {
  MuscleGroup? _selectedGroup;
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Exercise> _filter(List<Exercise> all) {
    var list = all;
    if (_selectedGroup != null) {
      list = list.where((e) => e.muscleGroup == _selectedGroup).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((e) => e.name.toLowerCase().contains(q)).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final all = ref.watch(exercisesProvider);
    final filtered = _filter(all);

    return GradientScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Упражнения',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/exercises/add'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (v) => setState(() => _searchQuery = v),
                decoration: InputDecoration(
                  hintText: 'Поиск упражнений...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchCtrl.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _AllChip(
                    selected: _selectedGroup == null,
                    onSelected: (_) => setState(() => _selectedGroup = null),
                  ),
                  ...MuscleGroup.values.map(
                    (g) => Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: MuscleGroupChip(
                        group: g,
                        selected: _selectedGroup == g,
                        onSelected: (_) => setState(() => _selectedGroup = g),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        'Нет упражнений.\nНажмите + чтобы добавить.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withAlpha(153),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) =>
                          _ExerciseTile(exercise: filtered[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AllChip extends StatelessWidget {
  final bool selected;
  final ValueChanged<bool> onSelected;

  const _AllChip({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FilterChip(
      label: const Text('Все',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
      selected: selected,
      onSelected: onSelected,
      selectedColor: scheme.primary,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(color: selected ? Colors.white : scheme.primary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}

class _ExerciseTile extends ConsumerWidget {
  final Exercise exercise;
  const _ExerciseTile({required this.exercise});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Hero(
        tag: 'exercise-${exercise.id}',
        child: GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              MuscleGroupChip(group: exercise.muscleGroup),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  exercise.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, color: scheme.error, size: 20),
                onPressed: () => _confirmDelete(context, ref),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Удалить упражнение?'),
        content: Text('«${exercise.name}» будет удалено.'),
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
    if (confirmed == true) {
      ref.read(exercisesProvider.notifier).deleteExercise(exercise.id);
    }
  }
}
