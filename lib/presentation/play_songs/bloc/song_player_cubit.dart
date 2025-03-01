import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/presentation/mini_player/bloc/mini_player_cubit.dart';
import 'package:music/presentation/play_songs/bloc/song_player_state.dart';

import '../../../domain/entities/song/song.dart';

class SongPlayerCubit extends Cubit<SongPlayerState> {
  final MiniPlayerCubit miniPlayerCubit;
  Timer? _syncTime;

  SongPlayerCubit({required this.miniPlayerCubit})
      : super(SongPlayerLoading()) {
    _syncTime = Timer.periodic(Duration(milliseconds: 200), (_) {
      _syncWithMiniPlayer();
    });
  }

  void _syncWithMiniPlayer() {
    final info = miniPlayerCubit.getCurrentPlaybackInfo();
    final currentSong = info['song'] as SongEntity?;

    if (currentSong != null) {
      emit(
        SongNowPlayingVisible(
          currentSong,
          info['isPlaying'] as bool,
          info['position'] as Duration,
          info['duration'] as Duration,
          info['isRepeat'] as bool,
          info['isShuffle'] as bool,
          info['dominantColor'] as Color,
          info['urlImage'] as String,
        ),
      );
    }
  }

  void playOrPauseSong() {
    miniPlayerCubit.playOrPauseSong();
    _syncWithMiniPlayer();
  }

  void seekTo(Duration position) {
    miniPlayerCubit.audioPlayer.seek(position);
    _syncWithMiniPlayer();
  }

  void repeatSong() {
    miniPlayerCubit.toggleRepeat();
    _syncWithMiniPlayer();
  }

  void shuffleSong() {
    miniPlayerCubit.toggleShuffle();
    _syncWithMiniPlayer();
  }

  void playNextSong() {
    final currentState = state;
    if (currentState is SongNowPlayingVisible) {
      emit(SongPlayerLoading());
    }

    miniPlayerCubit.playNextSong();

    final info = miniPlayerCubit.getCurrentPlaybackInfo();
    final newSong = info['song'] as SongEntity?;

    if (newSong != null) {
      emit(
        SongNowPlayingVisible(
          newSong,
          true,
          Duration.zero,
          info['duration'] as Duration,
          info['isRepeat'] as bool,
          info['isShuffle'] as bool,
          info['dominantColor'] as Color,
          info['urlImage'] as String,
        ),
      );
    }
  }

  void playPreviousSong() {
    miniPlayerCubit.playPreviousSong();
    _syncWithMiniPlayer();
  }

  @override
  Future<void> close() {
    _syncTime?.cancel();
    return super.close();
  }
}
