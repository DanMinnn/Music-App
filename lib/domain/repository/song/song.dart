import 'package:dartz/dartz.dart';

abstract class SongsRepository {
  Future<Either> getNewsSong();
  Future<Either> getPlaylist();
  Future<Either> addOrRemoveFavorite(String songId);
  Future<bool> isFavorites(String songId);
  Future<Either> getUserFavoriteSongs();
}
