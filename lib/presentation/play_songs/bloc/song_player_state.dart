import 'package:flutter/material.dart';
import 'package:music/domain/entities/song/song.dart';

abstract class SongPlayerState {}

class SongPlayerLoading extends SongPlayerState {}

class SongPlayerLoaded extends SongPlayerState {}

class SongPlayerFailure extends SongPlayerState {}

class SongNowPlayingVisible extends SongPlayerState {
  final SongEntity songEntity;
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final bool isRepeat;
  final bool isShuffle;
  final Color dominantColor;
  final String urlImage;

  SongNowPlayingVisible(
    this.songEntity,
    this.isPlaying,
    this.position,
    this.duration,
    this.isRepeat,
    this.isShuffle,
    this.dominantColor,
    this.urlImage,
  );
}
