import 'package:flutter/material.dart';
import 'package:booklook/domain/entities/set_data.dart';

class SetRowWidget extends StatefulWidget {
  final int index;
  final SetData? initial;
  final void Function(SetData) onChanged;
  final VoidCallback onDelete;

  const SetRowWidget({
    super.key,
    required this.index,
    required this.onChanged,
    required this.onDelete,
    this.initial,
  });

  @override
  State<SetRowWidget> createState() => _SetRowWidgetState();
}

class _SetRowWidgetState extends State<SetRowWidget> {
  late final TextEditingController _weightCtrl;
  late final TextEditingController _repsCtrl;

  @override
  void initState() {
    super.initState();
    _weightCtrl = TextEditingController(
      text: widget.initial?.weight.toString() ?? '',
    );
    _repsCtrl = TextEditingController(
      text: widget.initial?.reps.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _weightCtrl.dispose();
    _repsCtrl.dispose();
    super.dispose();
  }

  void _notify() {
    final weight = double.tryParse(_weightCtrl.text) ?? 0.0;
    final reps = int.tryParse(_repsCtrl.text) ?? 0;
    widget.onChanged(SetData(weight: weight, reps: reps));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: scheme.primary.withAlpha(51),
            ),
            child: Text(
              '${widget.index}',
              style: TextStyle(
                color: scheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _weightCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                hintText: 'кг',
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              onChanged: (_) => _notify(),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _repsCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'повт.',
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              onChanged: (_) => _notify(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, size: 20),
            color: scheme.error,
            onPressed: widget.onDelete,
          ),
        ],
      ),
    );
  }
}
