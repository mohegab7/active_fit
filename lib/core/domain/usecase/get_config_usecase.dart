import 'package:active_fit/core/data/repository/config_repository.dart';
import 'package:active_fit/core/domain/entity/config_entity.dart';

class GetConfigUsecase {
  final ConfigRepository _configRepository;

  GetConfigUsecase(this._configRepository);

  Future<ConfigEntity> getConfig() async {
    return await _configRepository.getConfig();
  }
}
