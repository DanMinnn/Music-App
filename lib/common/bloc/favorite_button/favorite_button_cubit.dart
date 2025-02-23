import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/common/bloc/favorite_button/favorite_button_state.dart';
import 'package:music/domain/usecases/song/add_or_remove_favorites_song.dart';
import 'package:music/service_locator.dart';

class FavoritesButtonCubit extends Cubit<FavoritesButtonState> {
  FavoritesButtonCubit() : super(FavoritesButtonInitial());

  Future<void> favoritesButtonUpdated(String songId) async {
    var result =
        await sl<AddOrRemoveFavoritesSongUseCase>().call(params: songId);

    result.fold((l) {}, (isFavorites) {
      emit(FavoritesButtonUpdate(isFavorites: isFavorites));
    });
  }
}
