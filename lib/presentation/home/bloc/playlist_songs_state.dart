import 'package:music/domain/entities/song/song.dart';

abstract class PlaylistSongsState {}

class PlaylistSongLoading extends PlaylistSongsState {}

class PlaylistSongLoaded extends PlaylistSongsState {
  final List<SongEntity> songs;
  PlaylistSongLoaded({required this.songs});
}

class PlaylistSongLoadFailure extends PlaylistSongsState {}
