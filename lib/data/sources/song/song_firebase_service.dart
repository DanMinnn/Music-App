import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:music/data/models/song/song.dart';
import 'package:music/domain/entities/song/song.dart';
import 'package:music/domain/usecases/song/is_favorites_song.dart';
import 'package:music/service_locator.dart';

abstract class SongFirebaseService {
  Future<Either> getNewsSongs();

  Future<Either> getPlaylist();

  Future<Either> addOrRemoveFavorite(String songId);
  Future<bool> isFavorites(String songId);
}

class SongFirebaseServiceImpl extends SongFirebaseService {
  @override
  Future<Either> getNewsSongs() async {
    try {
      List<SongEntity> songs = [];
      var data = await FirebaseFirestore.instance
          .collection('Songs')
          .orderBy('releaseDate', descending: true)
          .limit(3)
          .get();
      for (var element in data.docs) {
        var songModel = SongModel.fromJson(element.data());
        bool isFavorites = await sl<IsFavoritesSongUseCase>()
            .call(params: element.reference.id);
        songModel.isFavorites = isFavorites;
        songModel.songId = element.reference.id;
        songs.add(songModel.toEntity());
      }

      return Right(songs);
    } catch (e) {
      return Left('An error occurred, Please try again.');
    }
  }

  @override
  Future<Either> getPlaylist() async {
    try {
      List<SongEntity> songs = [];
      var data = await FirebaseFirestore.instance
          .collection('Songs')
          .orderBy('releaseDate', descending: true)
          .get();

      for (var element in data.docs) {
        var songModel = SongModel.fromJson(element.data());
        bool isFavorites = await sl<IsFavoritesSongUseCase>()
            .call(params: element.reference.id);
        songModel.isFavorites = isFavorites;
        songModel.songId = element.reference.id;
        songs.add(songModel.toEntity());
      }

      return Right(songs);
    } catch (e) {
      return Left('An error occurred, Please try again.');
    }
  }

  @override
  Future<Either> addOrRemoveFavorite(String songId) async {
    try {
      final firebaseAuth = FirebaseAuth.instance;
      final fireStore = FirebaseFirestore.instance;

      late bool isFavorite;
      var user = firebaseAuth.currentUser;
      String uid = user!.uid;

      QuerySnapshot favoriteSong = await fireStore
          .collection('User')
          .doc(uid)
          .collection('Favorites')
          .where('songId', isEqualTo: songId)
          .get();

      if (favoriteSong.docs.isNotEmpty) {
        await favoriteSong.docs.first.reference.delete();
        isFavorite = false;
      } else {
        await fireStore
            .collection('User')
            .doc(uid)
            .collection('Favorites')
            .add({'songId': songId, 'addedDate': Timestamp.now()});
        isFavorite = true;
      }

      return Right(isFavorite);
    } catch (e) {
      return Left('An error occurred');
    }
  }

  @override
  Future<bool> isFavorites(String songId) async {
    try {
      final firebaseAuth = FirebaseAuth.instance;
      final fireStore = FirebaseFirestore.instance;

      var user = firebaseAuth.currentUser;
      String uid = user!.uid;

      QuerySnapshot favoriteSong = await fireStore
          .collection('User')
          .doc(uid)
          .collection('Favorites')
          .where('songId', isEqualTo: songId)
          .get();

      if (favoriteSong.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
