import 'package:dartz/dartz.dart';
import 'package:music/core/usecase/usecase.dart';
import 'package:music/domain/repository/song/song.dart';
import 'package:music/service_locator.dart';

class GetPlaylistSongUsecase implements UseCase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return await sl<SongsRepository>().getPlaylist();
  }
}
