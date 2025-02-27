import '../../../domain/entities/song/song.dart';

abstract class MiniPlayerState {}

class MiniPlayerInitial extends MiniPlayerState {}

class MiniPlayerLoading extends MiniPlayerState {}

class MiniPlayerLoaded extends MiniPlayerState {}

class MiniPlayerFailure extends MiniPlayerState {}

class MiniPlayerVisible extends MiniPlayerState {
  final SongEntity songEntity;
  final bool isLoading;
  MiniPlayerVisible(this.songEntity, {this.isLoading = false});
}
