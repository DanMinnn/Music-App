import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/domain/entities/song/song.dart';
import 'package:music/domain/usecases/song/get_favorite_song.dart';
import 'package:music/presentation/profile/bloc/favorite_songs_state.dart';
import 'package:music/service_locator.dart';

class FavoriteSongsCubit extends Cubit<FavoriteSongState> {
  FavoriteSongsCubit() : super(FavoriteSongLoading());

  List<SongEntity> favoriteSongs = [];

  Future<void> getFavoriteSongs() async {
    var result = await sl<GetFavoriteSongUseCase>().call();
    result.fold((l) {
      emit(FavoriteSongFailure());
    }, (r) {
      favoriteSongs = r;
      emit(FavoriteSongLoaded(favoriteSongs: favoriteSongs));
    });
  }

  void removeSong(int index) {
    favoriteSongs.removeAt(index);
    emit(FavoriteSongLoaded(favoriteSongs: favoriteSongs));
  }
}
