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

  SongNowPlayingVisible(
      this.songEntity, this.isPlaying, this.position, this.duration);
}
