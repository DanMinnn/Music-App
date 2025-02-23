import 'package:dartz/dartz.dart';
import 'package:music/data/sources/song/song_firebase_service.dart';
import 'package:music/domain/repository/song/song.dart';
import 'package:music/service_locator.dart';

class SongRepositoryImpl extends SongsRepository {
  @override
  Future<Either> getNewsSong() async {
    return await sl<SongFirebaseService>().getNewsSongs();
  }

  @override
  Future<Either> getPlaylist() async {
    return await sl<SongFirebaseService>().getPlaylist();
  }

  @override
  Future<Either> addOrRemoveFavorite(String songId) async {
    return await sl<SongFirebaseService>().addOrRemoveFavorite(songId);
  }

  @override
  Future<bool> isFavorites(String songId) async {
    return await sl<SongFirebaseService>().isFavorites(songId);
  }

  @override
  Future<Either> getUserFavoriteSongs() async {
    return await sl<SongFirebaseService>().getUserFavoriteSongs();
  }
}
