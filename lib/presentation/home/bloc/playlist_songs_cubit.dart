import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/domain/usecases/song/get_playlist_song.dart';
import 'package:music/presentation/home/bloc/playlist_songs_state.dart';
import 'package:music/service_locator.dart';

class PlaylistSongCubit extends Cubit<PlaylistSongsState> {
  PlaylistSongCubit() : super(PlaylistSongLoading());

  Future<void> getPlaylistSongs() async {
    var returnedSongs = await sl<GetPlaylistSongUsecase>().call();

    returnedSongs.fold((l) {
      emit(PlaylistSongLoadFailure());
    }, (data) {
      emit(PlaylistSongLoaded(songs: data));
    });
  }
}
