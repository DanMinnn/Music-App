import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/configs/theme/app_colors.dart';
import 'package:music/domain/entities/song/song.dart';
import 'package:music/presentation/mini_player/bloc/mini_player_cubit.dart';
import 'package:music/presentation/mini_player/bloc/mini_player_state.dart';
import 'package:music/presentation/play_songs/pages/song_player.dart';

class MusicSlab extends StatefulWidget {
  final SongEntity songEntity;

  const MusicSlab({super.key, required this.songEntity});

  @override
  State<MusicSlab> createState() => _MusicSlabState();
}

class _MusicSlabState extends State<MusicSlab> {
  /* Color dominantColor = Colors.redAccent;
  late String urlImage;

  @override
  void initState() {
    super.initState();
    _updateBackgroundColor();
  }

  @override
  void didUpdateWidget(covariant MusicSlab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.songEntity != widget.songEntity) {
      _updateBackgroundColor();
    }
  }

  Future<void> _updateBackgroundColor() async {
    urlImage =
        '${AppURLs.coversFireStorage}${Uri.encodeFull('${widget.songEntity.artist.replaceAll('\t', ' ').replaceAll(',', ' ,')} - '
            '${widget.songEntity.title}')}.jpg?${AppURLs.mediaAlt}';

    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(NetworkImage(urlImage));

    setState(() {
      dominantColor = paletteGenerator.dominantColor?.color ?? Colors.redAccent;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MiniPlayerCubit, MiniPlayerState>(
      builder: (context, state) {
        Color dominantColor = Colors.redAccent;
        String urlImage = '';

        if (state is MiniPlayerVisible) {
          dominantColor = state.dominantColor;
          urlImage = state.urlImage;
        }
        final cubit = context.read<MiniPlayerCubit>();
        final position = cubit.songPosition.inMilliseconds.toDouble();
        final duration = cubit.songDuration.inMilliseconds.toDouble();
        final progress = duration > 0 ? position / duration : 0.0;
        final isPlaying = cubit.audioPlayer.playing;

        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SongPlayer(songEntity: widget.songEntity)));
          },
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                padding: EdgeInsets.fromLTRB(10, 0, 5, 5),
                margin: EdgeInsets.fromLTRB(6, 0, 12, 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: dominantColor.withOpacity(0.8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(urlImage),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.songEntity.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              widget.songEntity.artist,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            cubit.playOrPauseSong();
                            /*if (isComplete) {
                                cubit.seekToStart();
                                cubit.playSong();
                              } else {
                                cubit.playOrPauseSong();
                              }*/
                          },
                          icon: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            color: AppColors.darkGrey,
                            size: 24,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.favorite,
                            size: 24,
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 15,
                child: Container(
                  height: 5,
                  width: MediaQuery.of(context).size.width - 28,
                  decoration: BoxDecoration(
                    color: AppColors.darkGrey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 15,
                child: Container(
                  height: 5,
                  width: (MediaQuery.of(context).size.width - 28) * progress,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
