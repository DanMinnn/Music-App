import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/common/helper/is_dark.dart';
import 'package:music/common/widgets/appbar/app_bar.dart';
import 'package:music/common/widgets/favorite_button/favorite_button.dart';
import 'package:music/core/configs/constant/app_urls.dart';
import 'package:music/presentation/play_songs/pages/song_player.dart';
import 'package:music/presentation/profile/bloc/favorite_songs_cubit.dart';
import 'package:music/presentation/profile/bloc/favorite_songs_state.dart';
import 'package:music/presentation/profile/bloc/profile_info_cubit.dart';
import 'package:music/presentation/profile/bloc/profile_info_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        backgroundColor: Color(0xFF2C2B2B),
        title: Text('Profile'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _profileInfo(context),
          SizedBox(
            height: 15,
          ),
          _favoriteSongs(),
        ],
      ),
    );
  }

  Widget _profileInfo(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileInfoCubit()..getUser(),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 3.5,
        decoration: BoxDecoration(
          color: context.isDarkMode ? Color(0xFF2C2B2B) : Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
        ),
        child: BlocBuilder<ProfileInfoCubit, ProfileInfoState>(
            builder: (context, state) {
          if (state is ProfileInfoLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is ProfileInfoLoaded) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(state.userEntity.imgUrl!),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(state.userEntity.email!),
                SizedBox(
                  height: 8,
                ),
                Text(
                  state.userEntity.fullName!,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            );
          }
          if (state is ProfileInfoFailure) {
            return Text('Please try again');
          }
          return Container();
        }),
      ),
    );
  }

  Widget _favoriteSongs() {
    return BlocProvider(
      create: (context) => FavoriteSongsCubit()..getFavoriteSongs(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Favorite songs',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            SizedBox(
              height: 15,
            ),
            BlocBuilder<FavoriteSongsCubit, FavoriteSongState>(
                builder: (context, state) {
              if (state is FavoriteSongLoading) {
                return CircularProgressIndicator();
              }
              if (state is FavoriteSongLoaded) {
                return ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SongPlayer(
                                  songEntity: state.favoriteSongs[index]),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          '${AppURLs.coversFireStorage}${Uri.encodeFull('${state.favoriteSongs[index].artist} - '
                                              '${state.favoriteSongs[index].title}')}.jpg?${AppURLs.mediaAlt}'),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 25,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.favoriteSongs[index].title,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      state.favoriteSongs[index].artist,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  state.favoriteSongs[index].duration
                                      .toString()
                                      .replaceAll('.', ':'),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                FavoriteButton(
                                  songEntity: state.favoriteSongs[index],
                                  key: UniqueKey(),
                                  function: () {
                                    context
                                        .read<FavoriteSongsCubit>()
                                        .removeSong(index);
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemCount: state.favoriteSongs.length);
              }
              if (state is FavoriteSongFailure) {}
              return Container();
            })
          ],
        ),
      ),
    );
  }

/*Widget _songFavoriteDetail(List<SongEntity> songs) {

  }*/
}
