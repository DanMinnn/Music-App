import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/presentation/mini_player/bloc/mini_player_state.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../../core/configs/constant/app_urls.dart';
import '../../../domain/entities/song/song.dart';

class MiniPlayerCubit extends Cubit<MiniPlayerState> {
  AudioPlayer audioPlayer = AudioPlayer();
  Duration songDuration = Duration.zero;
  Duration songPosition = Duration.zero;
  SongEntity? currentSong;

  bool isRepeat = false;
  bool isShuffle = false;
  Color dominantColor = Colors.redAccent;
  String currentUrlImage = '';

  List<SongEntity> playlist = [];
  int currentIndex = -1;

  MiniPlayerCubit() : super(MiniPlayerInitial()) {
    audioPlayer.positionStream.listen((position) {
      songPosition = position;
      updateSongPlayer();
    });

    audioPlayer.durationStream.listen((duration) {
      songDuration = duration!;
      updateSongPlayer();
    });

    //when song is finished
    audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        if (isRepeat) {
          audioPlayer.seek(Duration.zero);
          audioPlayer.play();
        } else {
          playNextSong();
        }
      }
    });
  }

  void updateSongPlayer() {
    final currentState = state;
    // Only update if player is visible
    if (currentState is MiniPlayerVisible && currentSong != null) {
      emit(MiniPlayerVisible(
        currentSong!,
        isLoading: false,
        isRepeat: false,
        isShuffle: false,
        dominantColor: dominantColor,
        urlImage: currentUrlImage,
      ));
    }
  }

  Future<void> loadSong(String url) async {
    try {
      await audioPlayer.setUrl(url);
      await audioPlayer.play();
    } catch (e) {
      print("Error loading song: $e");
      if (currentSong != null) {
        emit(MiniPlayerVisible(
          currentSong!,
          isLoading: false,
          isRepeat: false,
          isShuffle: false,
          dominantColor: dominantColor,
          urlImage: currentUrlImage,
        ));
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

  Future<void> updateDominantColor(SongEntity song) async {
    final imageUrl =
        '${AppURLs.coversFireStorage}${Uri.encodeFull('${song.artist.replaceAll('\t', ' ').replaceAll(',', ' ,')} - ${song.title}')}.jpg?${AppURLs.mediaAlt}';
    currentUrlImage = imageUrl;

    try {
      final PaletteGenerator paletteGenerator =
          await PaletteGenerator.fromImageProvider(NetworkImage(imageUrl));
      dominantColor = paletteGenerator.dominantColor?.color ?? Colors.blueGrey;
      updateSongPlayer();
    } catch (e) {
      print("Error generating palette: $e");
      dominantColor = Colors.blueGrey;
      updateSongPlayer();
    }
  }

  Future<void> showPlayer(SongEntity song,
      {List<SongEntity>? playlist, int? index, bool? isCheckPlaying}) async {
    bool isSameSong = currentSong?.songId == song.songId;

    // Handle play/pause toggle if it's the same song
    if (isSameSong && isCheckPlaying != null) {
      if (isCheckPlaying) {
        await audioPlayer.pause();
        emit(MiniPlayerVisible(
          song,
          isLoading: false,
          isPlaying: false, // Add isPlaying state
          isRepeat: isRepeat,
          isShuffle: isShuffle,
          dominantColor: dominantColor,
          urlImage: currentUrlImage,
        ));
      } else {
        await audioPlayer.play();
        emit(MiniPlayerVisible(
          song,
          isLoading: false,
          isPlaying: true, // Add isPlaying state
          isRepeat: isRepeat,
          isShuffle: isShuffle,
          dominantColor: dominantColor,
          urlImage: currentUrlImage,
        ));
      }
      return;
    }
    // Update current song reference
    currentSong = song;

    //update playlist if provided
    if (playlist != null && index != null) {
      this.playlist = List.from(playlist);
      currentIndex = index;
    } else {
      //if not, add current song
      this.playlist = [song];
      currentIndex = 0;
    }

    // Show player with loading state
    emit(MiniPlayerVisible(
      song,
      isLoading: true,
      isPlaying: false,
      isRepeat: isRepeat,
      isShuffle: isShuffle,
      dominantColor: dominantColor,
      urlImage: currentUrlImage,
    ));

    await updateDominantColor(song);

    // Then load the new song
    loadSong(
        '${AppURLs.songsFireStorage}${Uri.encodeFull('${song.artist.replaceAll('\t', ' ').replaceAll(',', ' ,')} - ${song.title}')}.mp3?${AppURLs.mediaAlt}');

    await audioPlayer.play();

    // Update state after successful play
    emit(MiniPlayerVisible(
      song,
      isLoading: false,
      isPlaying: true,
      isRepeat: isRepeat,
      isShuffle: isShuffle,
      dominantColor: dominantColor,
      urlImage: currentUrlImage,
    ));
  }

  // Phương thức để cung cấp thông tin hiện tại cho SongPlayerCubit
  Map<String, dynamic> getCurrentPlaybackInfo() {
    return {
      'song': currentSong,
      'isPlaying': audioPlayer.playing,
      'position': songPosition,
      'duration': songDuration,
      'isRepeat': isRepeat,
      'isShuffle': isShuffle,
      'audioUrl': currentSong != null
          ? '${AppURLs.songsFireStorage}${Uri.encodeFull('${currentSong!.artist.replaceAll('\t', ' ').replaceAll(',', ' ,')} '
              '- ${currentSong!.title}')}.mp3?${AppURLs.mediaAlt}'
          : null,
      'dominantColor': dominantColor,
      'urlImage': currentUrlImage,
    };
  }

  void toggleRepeat() {
    isRepeat = !isRepeat;
    updateSongPlayer();
  }

  void toggleShuffle() {
    isShuffle = !isShuffle;
    updateSongPlayer();
  }

  Future<void> playNextSong() async {
    if (playlist.isEmpty || currentIndex == -1) return;

    int nextIndex;
    if (isShuffle) {
      final random = Random();
      if (playlist.length > 1) {
        do {
          nextIndex = random.nextInt(playlist.length);
        } while (nextIndex == currentIndex);
      } else {
        nextIndex = 0;
      }
    } else {
      nextIndex = (currentIndex + 1) % playlist.length;
    }

    currentIndex = nextIndex;
    currentSong = playlist[currentIndex];

    emit(MiniPlayerVisible(
      currentSong!,
      isLoading: true,
      isShuffle: isShuffle,
      isRepeat: isRepeat,
      dominantColor: dominantColor,
      urlImage: currentUrlImage,
    ));

    await updateDominantColor(currentSong!);

    loadSong(
        '${AppURLs.songsFireStorage}${Uri.encodeFull('${currentSong!.artist.replaceAll('\t', ' ').replaceAll(',', ' ,')} '
            '- ${currentSong!.title}')}.mp3?${AppURLs.mediaAlt}');
  }

  Future<void> playPreviousSong() async {
    if (playlist.isEmpty || currentIndex == -1) return;

    if (songPosition.inSeconds > 3) {
      audioPlayer.seek(Duration.zero);
      audioPlayer.play();
      return;
    }

    int previousIndex;
    if (isShuffle) {
      final random = Random();
      if (playlist.length > 1) {
        do {
          previousIndex = random.nextInt(playlist.length);
        } while (previousIndex == currentIndex);
      } else {
        previousIndex = 0;
      }
    } else {
      previousIndex = (currentIndex - 1 + playlist.length) % playlist.length;
    }

    currentIndex = previousIndex;
    currentSong = playlist[currentIndex];

    emit(MiniPlayerVisible(
      currentSong!,
      isLoading: true,
      isShuffle: isShuffle,
      isRepeat: isRepeat,
      dominantColor: dominantColor,
      urlImage: currentUrlImage,
    ));

    await updateDominantColor(currentSong!);

    loadSong(
        '${AppURLs.songsFireStorage}${Uri.encodeFull('${currentSong!.artist.replaceAll('\t', ' ').replaceAll(',', ' ,')} '
            '- ${currentSong!.title}')}.mp3?${AppURLs.mediaAlt}');
  }

  @override
  Future<void> close() {
    audioPlayer.dispose();
    return super.close();
  }
}
