import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/common/helper/is_dark.dart';
import 'package:music/common/widgets/favorite_button/favorite_button.dart';
import 'package:music/core/configs/theme/app_colors.dart';
import 'package:music/domain/entities/song/song.dart';
import 'package:music/presentation/home/bloc/playlist_songs_cubit.dart';
import 'package:music/presentation/home/bloc/playlist_songs_state.dart';
import 'package:music/presentation/mini_player/bloc/mini_player_cubit.dart';

class PlayListSongs extends StatefulWidget {
  const PlayListSongs({super.key});

  @override
  State<PlayListSongs> createState() => _PlayListSongsState();
}

class _PlayListSongsState extends State<PlayListSongs> {
  bool isPress = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlaylistSongCubit()..getPlaylistSongs(),
      child: SizedBox(
        child: BlocBuilder<PlaylistSongCubit, PlaylistSongsState>(
          builder: (context, state) {
            if (state is PlaylistSongLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is PlaylistSongLoaded) {
              final miniPlayerCubit = context.read<MiniPlayerCubit>();

              return Padding(
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Playlist',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                        StreamBuilder<PlayerState>(
                          stream: miniPlayerCubit.audioPlayer.playerStateStream,
                          builder: (context, snapshot) {
                            final playerState = snapshot.data;
                            final isPlaying = playerState?.playing ?? false;
                            final isSameSong =
                                miniPlayerCubit.currentSong?.songId ==
                                    state.songs.first.songId;
                            final isProcessing = playerState?.processingState ==
                                    ProcessingState.loading ||
                                playerState?.processingState ==
                                    ProcessingState.buffering;

                            return GestureDetector(
                              onTap: () async {
                                if (isProcessing)
                                  return; // Prevent action during loading

                                if (isSameSong) {
                                  miniPlayerCubit.showPlayer(
                                    state.songs.first,
                                    isCheckPlaying: isPlaying,
                                  );
                                } else {
                                  await miniPlayerCubit.showPlayer(
                                    state.songs.first,
                                    playlist: state.songs,
                                    index: 0,
                                  );
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primary,
                                ),
                                child: Icon(
                                  isProcessing
                                      ? Icons.hourglass_empty
                                      : (isPlaying && isSameSong
                                          ? Icons.pause
                                          : Icons.play_arrow),
                                  size: 20,
                                  color: Colors.black,
                                ),
                              ),
                            );
                            return Center(
                              child: Text('No playlist available'),
                            );
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    _songs(state.songs),
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _songs(List<SongEntity> songs) {
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              /*Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SongPlayer(
                    songEntity: songs[index],
                  ),
                ),
              );*/
              context.read<MiniPlayerCubit>().showPlayer(songs[index]);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.isDarkMode
                            ? AppColors.darkGrey
                            : Color(0xFFE6E6E6),
                      ),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: context.isDarkMode
                            ? Color(0xFF959595)
                            : Color(0xFF555555),
                      ),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          songs[index].title,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          songs[index].artist,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      songs[index].duration.toString().replaceAll('.', ':'),
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    FavoriteButton(songEntity: songs[index]),
                  ],
                )
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(
              height: 10,
            ),
        itemCount: songs.length);
  }
}
