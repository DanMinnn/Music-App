import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/common/widgets/appbar/app_bar.dart';
import 'package:music/common/widgets/favorite_button/favorite_button.dart';
import 'package:music/core/configs/assets/app_images.dart';
import 'package:music/core/configs/theme/app_colors.dart';
import 'package:music/domain/entities/song/song.dart';
import 'package:music/presentation/mini_player/bloc/mini_player_cubit.dart';
import 'package:music/presentation/play_songs/bloc/song_player_cubit.dart';
import 'package:music/presentation/play_songs/bloc/song_player_state.dart';

class SongPlayer extends StatefulWidget {
  final SongEntity songEntity;

  const SongPlayer({super.key, required this.songEntity});

  @override
  State<SongPlayer> createState() => _SongPlayerState();
}

class _SongPlayerState extends State<SongPlayer> {
  /*late String urlImage;
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
  }*/

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SongPlayerCubit(
        miniPlayerCubit: context.read<MiniPlayerCubit>(),
      ),
      child: BlocBuilder<SongPlayerCubit, SongPlayerState>(
        builder: (context, state) {
          if (state is SongNowPlayingVisible) {
            return Scaffold(
              backgroundColor: state.dominantColor.withOpacity(0.8),
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
              body: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    _songCover(context, state),
                    SizedBox(
                      height: 17,
                    ),
                    _songDetail(state),
                    SizedBox(height: 5),
                    _songPlayer(context, state),
                  ],
                ),
              ),
            );
          }
          return Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _songCover(BuildContext context, SongNowPlayingVisible state) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(state.urlImage),
        ),
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }

  Widget _songDetail(SongNowPlayingVisible state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.songEntity.title,
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
                state.songEntity.artist,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        SizedBox(width: 16),
        FavoriteButton(songEntity: state.songEntity),
      ],
    );
  }

  Widget _songPlayer(BuildContext context, SongNowPlayingVisible state) {
    final cubit = context.read<SongPlayerCubit>();

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.white,
            inactiveTrackColor: Color(0xFF777777),
            trackShape: RoundedRectSliderTrackShape(),
            trackHeight: 3.0,
            thumbColor: Colors.white,
          ),
          child: Slider(
            value: state.position.inSeconds.toDouble(),
            min: 0.0,
            max: state.duration.inSeconds > 0
                ? state.duration.inSeconds.toDouble()
                : 1.0,
            onChanged: (value) {
              cubit.seekTo(Duration(seconds: value.toInt()));
            },
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 13),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatDuration(state.position),
                style: TextStyle(fontSize: 12),
              ),
              Text(
                '-${formatDuration(state.duration - state.position)}',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        _actionSong(context, state),
      ],
    );
  }

  Widget _actionSong(BuildContext context, SongNowPlayingVisible state) {
    final cubit = context.read<SongPlayerCubit>();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              cubit.repeatSong();
            },
            icon: state.isRepeat
                ? Image.asset(
                    AppImages.repeatSong,
                    color: AppColors.primary,
                  )
                : Image.asset(AppImages.repeatSong),
          ),
          IconButton(
            onPressed: () {
              cubit.playPreviousSong();
            },
            icon: Image.asset(AppImages.previousSong),
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
          IconButton(
            onPressed: () {
              cubit.playNextSong();
            },
            icon: Image.asset(AppImages.nextSong),
          ),
          IconButton(
            onPressed: () {
              cubit.shuffleSong();
            },
            icon: state.isShuffle
                ? Image.asset(
                    AppImages.shuffleSong,
                    color: AppColors.primary,
                  )
                : Image.asset(AppImages.shuffleSong),
          ),
        ],
      ),
    );
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
