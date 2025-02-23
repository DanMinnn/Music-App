import 'package:dartz/dartz.dart';
import 'package:music/core/usecase/usecase.dart';
import 'package:music/domain/repository/song/song.dart';
import 'package:music/service_locator.dart';

class AddOrRemoveFavoritesSongUseCase implements UseCase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return await sl<SongsRepository>().addOrRemoveFavorite(params!);
  }
}
