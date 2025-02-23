import 'package:music/core/usecase/usecase.dart';
import 'package:music/domain/repository/song/song.dart';
import 'package:music/service_locator.dart';

class IsFavoritesSongUseCase implements UseCase<bool, String> {
  @override
  Future<bool> call({String? params}) async {
    return await sl<SongsRepository>().isFavorites(params!);
  }
}
