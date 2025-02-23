import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/domain/usecases/song/get_news_song.dart';
import 'package:music/presentation/home/bloc/news_song_state.dart';
import 'package:music/service_locator.dart';

class NewsSongCubit extends Cubit<NewsSongState> {
  NewsSongCubit() : super(NewsSongLoading());

  Future<void> getNewsSong() async {
    var returnedSongs = await sl<GetNewsSongUseCase>().call();

    returnedSongs.fold((l) {
      emit(NewsSongLoadFailure());
    }, (data) {
      emit(NewsSongLoaded(songs: data));
    });
  }
}
