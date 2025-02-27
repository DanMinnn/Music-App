import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/common/widgets/appbar/app_bar.dart';
import 'package:music/common/widgets/favorite_button/favorite_button.dart';
import 'package:music/core/configs/constant/app_urls.dart';
import 'package:music/core/configs/theme/app_colors.dart';
import 'package:music/domain/entities/song/song.dart';
import 'package:music/presentation/mini_player/bloc/mini_player_cubit.dart';
import 'package:music/presentation/play_songs/bloc/song_player_cubit.dart';
import 'package:music/presentation/play_songs/bloc/song_player_state.dart';
import 'package:palette_generator/palette_generator.dart';

class SongPlayer extends StatefulWidget {
  final SongEntity songEntity;

  const SongPlayer({super.key, required this.songEntity});

  @override
  State<SongPlayer> createState() => _SongPlayerState();
}

class _SongPlayerState extends State<SongPlayer> {
  late String urlImage;
  Color dominantColor = Colors.blueGrey;
  @override
  void initState() {
    super.initState();
    _updateBackgroundColor();
  }

  @override
  void didUpdateWidget(covariant SongPlayer oldWidget) {
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
      dominantColor = paletteGenerator.dominantColor?.color ?? Colors.blueGrey;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SongPlayerCubit(
        miniPlayerCubit: context.read<MiniPlayerCubit>(),
      ),
      child: Scaffold(
        backgroundColor: dominantColor.withOpacity(0.8),
        appBar: BasicAppBar(
          title: Text(
            'Now playing',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          action: Icon(Icons.more_vert_rounded),
        ),
        body: BlocBuilder<SongPlayerCubit, SongPlayerState>(
          builder: (context, state) {
            if (state is SongNowPlayingVisible) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    _songCover(context),
                    SizedBox(
                      height: 17,
                    ),
                    _songDetail(),
                    SizedBox(
                      height: 17,
                    ),
                    _songPlayer(context, state),
                  ],
                ),
              );
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Widget _songCover(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(urlImage),
        ),
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }

  Widget _songDetail() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.songEntity.title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                widget.songEntity.artist,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        SizedBox(width: 16),
        FavoriteButton(songEntity: widget.songEntity),
      ],
    );
  }

  Widget _songPlayer(BuildContext context, SongNowPlayingVisible state) {
    final cubit = context.read<SongPlayerCubit>();

    return Column(
      children: [
        Slider(
          value: state.position.inSeconds.toDouble(),
          min: 0.0,
          max: state.duration.inSeconds > 0
              ? state.duration.inSeconds.toDouble()
              : 1.0,
          onChanged: (value) {
            cubit.seekTo(Duration(seconds: value.toInt()));
          },
          activeColor: Colors.white,
          inactiveColor: AppColors.darkGrey,
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formatDuration(state.position),
            ),
            Text(
              formatDuration(state.duration),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            cubit.playOrPauseSong();
          },
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
            child: Icon(
              state.isPlaying ? Icons.pause : Icons.play_arrow,
              size: 40,
            ),
          ),
        ),
      ],
    );
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
