import 'dart:math';

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

class _PlayListSongsState extends State<PlayListSongs>
    with SingleTickerProviderStateMixin {
  bool isPress = true;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..repeat(reverse: true); // Lặp lại sóng
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                              image: DecorationImage(
                                image: NetworkImage(
                                    AppURLs.urlImage(songs[index])),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isSameSong && isPlaying)
                                    _buildWaveAnimation(),
                                  if (isSameSong && isPlaying)
                                    SizedBox(width: 8),
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
                                ],
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

  Widget _buildWaveAnimation() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          children: List.generate(5, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 8 +
                    Random().nextInt(10) *
                        _controller.value, // Dao động ngẫu nhiên
                width: 4,
                decoration: BoxDecoration(
                  color: Colors.green, // Màu sóng
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
