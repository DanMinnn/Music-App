import 'package:dartz/dartz.dart';

abstract class SongsRepository {
  Future<Either> getNewsSong();
  Future<Either> getPlaylist();
}
