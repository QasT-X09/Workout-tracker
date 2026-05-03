import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:booklook/core/utils/date_utils.dart';
import 'package:booklook/domain/entities/exercise.dart';
import 'package:booklook/domain/entities/workout.dart';
import 'package:booklook/presentation/providers/exercise_provider.dart';
import 'package:booklook/presentation/providers/workout_provider.dart';
import 'package:booklook/presentation/widgets/glass_card.dart';
import 'package:booklook/presentation/widgets/gradient_scaffold.dart';
import 'package:booklook/presentation/widgets/muscle_group_chip.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  String? _selectedExerciseId;
  _ChartMode _mode = _ChartMode.volume;

  @override
  Widget build(BuildContext context) {
    final workouts = ref.watch(workoutsProvider);
    final exercises = ref.watch(exercisesProvider);
    final scheme = Theme.of(context).colorScheme;

    final weeklyPoints = _buildWeeklyPoints(workouts, exercises);

    return GradientScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Статистика',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ModeToggle(
                mode: _mode,
                onChange: (m) => setState(() => _mode = m),
              ),
              const SizedBox(height: 12),
              if (exercises.isNotEmpty) ...[
                Text('Фильтр по упражнению',
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 44,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      FilterChip(
                        label: const Text('Все'),
                        selected: _selectedExerciseId == null,
                        onSelected: (_) =>
                            setState(() => _selectedExerciseId = null),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      ...exercises.map((e) => Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: FilterChip(
                              label: Text(e.name,
                                  style: const TextStyle(fontSize: 12)),
                              selected: _selectedExerciseId == e.id,
                              onSelected: (_) =>
                                  setState(() => _selectedExerciseId = e.id),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _mode == _ChartMode.volume
                          ? 'Объём по неделям'
                          : 'Макс. вес по неделям',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: weeklyPoints.length < 2
                          ? Center(
                              child: Text(
                                'Недостаточно данных.\nПроведите хотя бы 2 тренировки.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: scheme.onSurface.withAlpha(128)),
                              ),
                            )
                          : _ProgressChart(points: weeklyPoints, mode: _mode),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (exercises.isNotEmpty) ...[
                Text('Статистика по упражнениям',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...exercises.map(
                    (e) => _ExerciseStatCard(exercise: e, workouts: workouts)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<_WeekPoint> _buildWeeklyPoints(
      List<Workout> workouts, List<Exercise> exercises) {
    var filtered = workouts;
    if (_selectedExerciseId != null) {
      filtered = workouts
          .where((w) =>
              w.exercises.any((e) => e.exerciseId == _selectedExerciseId))
          .toList();
    }

    final grouped = AppDateUtils.groupByWeek(filtered, (w) => w.date);
    final keys = grouped.keys.toList()..sort();

    return keys.map((key) {
      final ws = grouped[key]!;
      double volume = 0;
      double maxWeight = 0;
      for (final w in ws) {
        for (final we in w.exercises) {
          if (_selectedExerciseId != null &&
              we.exerciseId != _selectedExerciseId) {
            continue;
          }
          volume += we.totalVolume;
          if (we.maxWeight > maxWeight) maxWeight = we.maxWeight;
        }
      }
      return _WeekPoint(weekKey: key, volume: volume, maxWeight: maxWeight);
    }).toList();
  }
}

enum _ChartMode { volume, maxWeight }

class _WeekPoint {
  final String weekKey;
  final double volume;
  final double maxWeight;
  const _WeekPoint(
      {required this.weekKey, required this.volume, required this.maxWeight});
}

class _ModeToggle extends StatelessWidget {
  final _ChartMode mode;
  final ValueChanged<_ChartMode> onChange;

  const _ModeToggle({required this.mode, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Chip(
          label: 'Объём',
          selected: mode == _ChartMode.volume,
          onTap: () => onChange(_ChartMode.volume),
        ),
        const SizedBox(width: 8),
        _Chip(
          label: 'Макс. вес',
          selected: mode == _ChartMode.maxWeight,
          onTap: () => onChange(_ChartMode.maxWeight),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Chip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? scheme.primary : scheme.primary.withAlpha(26),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : scheme.primary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _ProgressChart extends StatelessWidget {
  final List<_WeekPoint> points;
  final _ChartMode mode;

  const _ProgressChart({required this.points, required this.mode});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final spots = points.asMap().entries.map((e) {
      final y = mode == _ChartMode.volume ? e.value.volume : e.value.maxWeight;
      return FlSpot(e.key.toDouble(), y);
    }).toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => FlLine(
            color: scheme.onSurface.withAlpha(26),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 48,
              getTitlesWidget: (val, _) => Text(
                '${val.toInt()}',
                style: TextStyle(
                    fontSize: 10, color: scheme.onSurface.withAlpha(153)),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (val, _) {
                final idx = val.toInt();
                if (idx < 0 || idx >= points.length) {
                  return const SizedBox();
                }
                final parts = points[idx].weekKey.split('-');
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '${parts[2]}.${parts[1]}',
                    style: TextStyle(
                        fontSize: 9, color: scheme.onSurface.withAlpha(153)),
                  ),
                );
              },
            ),
          ),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (spots) => spots
                .map((s) => LineTooltipItem(
                      mode == _ChartMode.volume
                          ? '${s.y.toInt()} кг×повт.'
                          : '${s.y} кг',
                      TextStyle(color: scheme.primary),
                    ))
                .toList(),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            gradient: LinearGradient(
              colors: [scheme.primary, scheme.secondary],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                radius: 5,
                color: scheme.primary,
                strokeWidth: 2,
                strokeColor: Colors.white,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  scheme.primary.withAlpha(64),
                  scheme.primary.withAlpha(0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseStatCard extends StatelessWidget {
  final Exercise exercise;
  final List<Workout> workouts;

  const _ExerciseStatCard({required this.exercise, required this.workouts});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    double totalVolume = 0;
    double maxWeight = 0;
    int totalSets = 0;

    for (final w in workouts) {
      for (final we in w.exercises) {
        if (we.exerciseId != exercise.id) continue;
        totalVolume += we.totalVolume;
        totalSets += we.sets.length;
        if (we.maxWeight > maxWeight) maxWeight = we.maxWeight;
      }
    }

    if (totalSets == 0) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                MuscleGroupChip(group: exercise.muscleGroup),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    exercise.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _StatItem(
                    label: 'Подходов',
                    value: '$totalSets',
                    color: scheme.primary),
                _StatItem(
                    label: 'Макс. вес',
                    value: '$maxWeight кг',
                    color: scheme.secondary),
                _StatItem(
                    label: 'Объём',
                    value: '${totalVolume.toInt()} кг',
                    color: scheme.tertiary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          Text(label,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
