import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/presentation/mini_player/bloc/mini_player_state.dart';

import '../../../core/configs/constant/app_urls.dart';
import '../../../domain/entities/song/song.dart';

class MiniPlayerCubit extends Cubit<MiniPlayerState> {
  AudioPlayer audioPlayer = AudioPlayer();
  Duration songDuration = Duration.zero;
  Duration songPosition = Duration.zero;
  SongEntity? currentSong;

  MiniPlayerCubit() : super(MiniPlayerInitial()) {
    audioPlayer.positionStream.listen((position) {
      songPosition = position;
      updateSongPlayer();
    });

    audioPlayer.durationStream.listen((duration) {
      songDuration = duration!;
      updateSongPlayer();
    });
  }

  void updateSongPlayer() {
    final currentState = state;
    // Only update if player is visible
    if (currentState is MiniPlayerVisible && currentSong != null) {
      emit(MiniPlayerVisible(currentSong!, isLoading: false));
    }
  }

  Future<void> loadSong(String url) async {
    try {
      await audioPlayer.setUrl(url);
      await audioPlayer.play();
    } catch (e) {
      print("Error loading song: $e");
      if (currentSong != null) {
        emit(MiniPlayerVisible(currentSong!, isLoading: false));
      } else {
        emit(MiniPlayerFailure());
      }
    }
  }

  void playOrPauseSong() {
    if (audioPlayer.playing) {
      audioPlayer.pause();
    } else {
      audioPlayer.play();
    }
    updateSongPlayer();
  }

  /*void seekToStart() {
    audioPlayer.seek(Duration.zero);
    emit(MiniPlayerLoaded());
  }

  void playSong() {
    audioPlayer.play();
    emit(MiniPlayerLoaded());
  }*/

  void showPlayer(SongEntity song) {
    // Stop current playback
    audioPlayer.stop();

    // Update current song reference
    currentSong = song;

    // Show player with loading state
    emit(MiniPlayerVisible(song, isLoading: true));

    // Then load the new song
    loadSong(
        '${AppURLs.songsFireStorage}${Uri.encodeFull('${song.artist.replaceAll('\t', ' ').replaceAll(',', ' ,')} - ${song.title}')}.mp3?${AppURLs.mediaAlt}');

    //emit(SongPlayerLoaded());
  }

  // Phương thức để cung cấp thông tin hiện tại cho SongPlayerCubit
  Map<String, dynamic> getCurrentPlaybackInfo() {
    return {
      'song': currentSong,
      'isPlaying': audioPlayer.playing,
      'position': songPosition,
      'duration': songDuration,
      'audioUrl': currentSong != null
          ? '${AppURLs.songsFireStorage}${Uri.encodeFull('${currentSong!.artist.replaceAll('\t', ' ').replaceAll(',', ' ,')} - ${currentSong!.title}')}.mp3?${AppURLs.mediaAlt}'
          : null
    };
  }

  @override
  Future<void> close() {
    audioPlayer.dispose();
    return super.close();
  }
}
