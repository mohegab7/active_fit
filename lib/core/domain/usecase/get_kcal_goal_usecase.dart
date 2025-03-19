import 'package:collection/collection.dart';
import 'package:active_fit/core/data/repository/config_repository.dart';
import 'package:active_fit/core/data/repository/user_activity_repository.dart';
import 'package:active_fit/core/data/repository/user_repository.dart';
import 'package:active_fit/core/domain/entity/user_entity.dart';
import 'package:active_fit/core/utils/calc/calorie_goal_calc.dart';

class GetKcalGoalUsecase {
  final UserRepository _userRepository;
  final ConfigRepository _configRepository;
  final UserActivityRepository _userActivityRepository;

  GetKcalGoalUsecase(this._userRepository, this._configRepository,
      this._userActivityRepository);

  Future<double> getKcalGoal(
      {UserEntity? userEntity,
      double? totalKcalActivitiesParam,
      double? kcalUserAdjustment}) async {
    final user = userEntity ?? await _userRepository.getUserData();
    final config = await _configRepository.getConfig();
    final totalKcalActivities = totalKcalActivitiesParam ??
        (await _userActivityRepository.getAllUserActivityByDate(DateTime.now()))
            .map((activity) => activity.burnedKcal)
            .toList()
            .sum;
    return CalorieGoalCalc.getTotalKcalGoal(user, totalKcalActivities,
        kcalUserAdjustment: config.userKcalAdjustment);
  }
}
