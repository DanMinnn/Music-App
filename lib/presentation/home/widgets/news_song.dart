import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/common/helper/is_dark.dart';
import 'package:music/core/configs/constant/app_urls.dart';
import 'package:music/core/configs/theme/app_colors.dart';
import 'package:music/domain/entities/song/song.dart';
import 'package:music/presentation/home/bloc/news_song_cubit.dart';
import 'package:music/presentation/home/bloc/news_song_state.dart';
import 'package:music/presentation/mini_player/bloc/mini_player_cubit.dart';

class NewsSong extends StatelessWidget {
  const NewsSong({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NewsSongCubit()..getNewsSong(),
      child: SizedBox(
        height: 200,
        child: BlocBuilder<NewsSongCubit, NewsSongState>(
          builder: (context, state) {
            if (state is NewsSongLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is NewsSongLoaded) {
              return _songs(state.songs);
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _songs(List<SongEntity> songs) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            /*Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MusicSlab(
                  songEntity: songs[index],
                ),
              ),
            );*/
            context.read<MiniPlayerCubit>().showPlayer(songs[index]);
          },
          child: Container(
            margin: EdgeInsets.only(left: 10),
            width: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(AppURLs.urlImage(songs[index])),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        height: 40,
                        width: 40,
                        transform: Matrix4.translationValues(10, 10, 0),
                        decoration: BoxDecoration(
                          color: context.isDarkMode
                              ? AppColors.darkGrey
                              : Color(0xFFE6E6E6),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: context.isDarkMode
                              ? Color(0xFF959595)
                              : Color(0xFF555555),
                        ),
                      ),
                    ),
                  ),
                ),
                /*Text('${AppURLs.coversFireStorage}${songs[index].artist}-${songs[index].title}.jpg?${AppURLs.mediaAlt}'),*/
                Text(
                  songs[index].title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  songs[index].artist,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => SizedBox(
        width: 14,
      ),
      itemCount: songs.length,
    );
  }
}
