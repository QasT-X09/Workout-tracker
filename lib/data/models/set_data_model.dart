import 'package:hive_flutter/hive_flutter.dart';
import 'package:booklook/domain/entities/set_data.dart';

part 'set_data_model.g.dart';

@HiveType(typeId: 1)
class SetDataModel extends HiveObject {
  @HiveField(0)
  late double weight;

  @HiveField(1)
  late int reps;

  SetDataModel();

  factory SetDataModel.fromEntity(SetData s) => SetDataModel()
    ..weight = s.weight
    ..reps = s.reps;

  SetData toEntity() => SetData(weight: weight, reps: reps);
}
