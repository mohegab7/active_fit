import 'package:hive/hive.dart';
import 'package:active_fit/core/data/dbo/intake_type_dbo.dart';
import 'package:active_fit/core/data/dbo/meal_dbo.dart';
import 'package:active_fit/core/domain/entity/intake_entity.dart';

part 'intake_dbo.g.dart';

@HiveType(typeId: 0)
class IntakeDBO extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String unit;
  @HiveField(2)
  double amount;
  @HiveField(3)
  IntakeTypeDBO type;

  @HiveField(4)
  MealDBO meal;

  @HiveField(5)
  DateTime dateTime;

  IntakeDBO(
      {required this.id,
      required this.unit,
      required this.amount,
      required this.type,
      required this.meal,
      required this.dateTime});

  factory IntakeDBO.fromIntakeEntity(IntakeEntity entity) {
    return IntakeDBO(
        id: entity.id,
        unit: entity.unit,
        amount: entity.amount,
        type: IntakeTypeDBO.fromIntakeTypeEntity(entity.type),
        meal: MealDBO.fromMealEntity(entity.meal),
        dateTime: entity.dateTime);
  }
}
