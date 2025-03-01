import 'package:flutter/material.dart';

import '../../../domain/entities/song/song.dart';

abstract class MiniPlayerState {}

class MiniPlayerInitial extends MiniPlayerState {}

class MiniPlayerLoading extends MiniPlayerState {}

class MiniPlayerLoaded extends MiniPlayerState {}

class MiniPlayerFailure extends MiniPlayerState {}

class MiniPlayerVisible extends MiniPlayerState {
  final SongEntity songEntity;
  final bool isLoading;
  final bool isPlaying;
  final bool isRepeat;
  final bool isShuffle;
  final String urlImage;
  final Color dominantColor;

  MiniPlayerVisible(this.songEntity,
      {this.isLoading = false,
      this.isRepeat = false,
      this.isPlaying = false,
      this.isShuffle = false,
      this.urlImage = '',
      this.dominantColor = Colors.redAccent});
}
