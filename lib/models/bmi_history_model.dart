import 'package:hive/hive.dart';

part 'bmi_history_model.g.dart';

@HiveType(typeId: 0)
class BmiHistoryModel extends HiveObject {
  @HiveField(0)
  final double bmi;

  @HiveField(1)
  final String result;

  @HiveField(2)
  final String interpretation;

  @HiveField(3)
  final int age;

  @HiveField(4)
  final int weight;

  @HiveField(5)
  final double height;

  @HiveField(6)
  final bool isMale;

  @HiveField(7)
  final DateTime date;

  BmiHistoryModel({
    required this.bmi,
    required this.result,
    required this.interpretation,
    required this.age,
    required this.weight,
    required this.height,
    required this.isMale,
    required this.date,
  });
}