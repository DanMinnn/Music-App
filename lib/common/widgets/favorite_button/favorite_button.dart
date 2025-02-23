import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/common/bloc/favorite_button/favorite_button_cubit.dart';
import 'package:music/common/bloc/favorite_button/favorite_button_state.dart';
import 'package:music/core/configs/theme/app_colors.dart';
import 'package:music/domain/entities/song/song.dart';

class FavoriteButton extends StatelessWidget {
  final SongEntity songEntity;
  final Function? function;
  const FavoriteButton({required this.songEntity, this.function, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FavoritesButtonCubit(),
      child: BlocBuilder<FavoritesButtonCubit, FavoritesButtonState>(
          builder: (context, state) {
        if (state is FavoritesButtonInitial) {
          return IconButton(
            onPressed: () async {
              await context
                  .read<FavoritesButtonCubit>()
                  .favoritesButtonUpdated(songEntity.songId);
              if (function != null) {
                function!();
              }
            },
            icon: Icon(
              songEntity.isFavorites
                  ? Icons.favorite
                  : Icons.favorite_border_outlined,
              size: 25,
              color: AppColors.darkGrey,
            ),
          );
        }
        if (state is FavoritesButtonUpdate) {
          return IconButton(
            onPressed: () {
              context
                  .read<FavoritesButtonCubit>()
                  .favoritesButtonUpdated(songEntity.songId);
            },
            icon: Icon(
              state.isFavorites
                  ? Icons.favorite
                  : Icons.favorite_border_outlined,
              size: 25,
              color: AppColors.darkGrey,
            ),
          );
        }
        return Container();
      }),
    );
  }
}
