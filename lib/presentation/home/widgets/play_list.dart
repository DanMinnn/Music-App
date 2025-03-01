import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/common/widgets/favorite_button/favorite_button.dart';
import 'package:music/core/configs/theme/app_colors.dart';
import 'package:music/domain/entities/song/song.dart';
import 'package:music/presentation/home/bloc/playlist_songs_cubit.dart';
import 'package:music/presentation/home/bloc/playlist_songs_state.dart';
import 'package:music/presentation/mini_player/bloc/mini_player_cubit.dart';

import '../../../core/configs/constant/app_urls.dart';

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
          return StreamBuilder<PlayerState>(
              stream:
                  context.read<MiniPlayerCubit>().audioPlayer.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final isPlaying = playerState?.playing ?? false;
                final isSameSong =
                    context.read<MiniPlayerCubit>().currentSong?.songId ==
                        songs[index].songId;
                final isProcessing = playerState?.processingState ==
                        ProcessingState.loading ||
                    playerState?.processingState == ProcessingState.buffering;

                return GestureDetector(
                  onTap: () {
                    if (isProcessing) return;

                    context.read<MiniPlayerCubit>().showPlayer(songs[index]);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                '${AppURLs.coversFireStorage}${Uri.encodeFull('${songs[index].artist.replaceAll('\t', ' ').replaceAll(',', ' ,')} '
                                    '- ${songs[index].title}')}.jpg?${AppURLs.mediaAlt}',
                                fit: BoxFit.cover,
                                width: 60,
                                height: 60,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.network(
                                    '${AppURLs.coversFireStorage}${Uri.encodeFull('${songs[index].artist.replaceAll('\t', ' ').replaceAll(',', ' ,')} '
                                        '- ${songs[index].title.toLowerCase()}')}.jpg?${AppURLs.mediaAlt}',
                                    fit: BoxFit.cover,
                                    width: 60,
                                    height: 60,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey,
                                        child: Center(
                                            child: Icon(Icons.broken_image,
                                                color: Colors.white)),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              (isSameSong && isPlaying)
                                  ? Text(
                                      songs[index].title,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary),
                                    )
                                  : Text(
                                      songs[index].title,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
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
                            songs[index]
                                .duration
                                .toString()
                                .replaceAll('.', ':'),
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400),
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
              });
        },
        separatorBuilder: (context, index) => SizedBox(
              height: 10,
            ),
        itemCount: songs.length);
  }
}
