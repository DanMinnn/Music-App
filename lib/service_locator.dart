import 'package:get_it/get_it.dart';
import 'package:music/data/repository/auth/auth_repository_impl.dart';
import 'package:music/data/repository/song/song_repository_impl.dart';
import 'package:music/data/sources/auth/auth_firebase_service.dart';
import 'package:music/data/sources/song/song_firebase_service.dart';
import 'package:music/domain/repository/auth/auth.dart';
import 'package:music/domain/repository/song/song.dart';
import 'package:music/domain/usecases/auth/get_user_use_case.dart';
import 'package:music/domain/usecases/auth/signin_use_case.dart';
import 'package:music/domain/usecases/auth/signup_use_case.dart';
import 'package:music/domain/usecases/song/add_or_remove_favorites_song.dart';
import 'package:music/domain/usecases/song/get_favorite_song.dart';
import 'package:music/domain/usecases/song/get_news_song.dart';
import 'package:music/domain/usecases/song/get_playlist_song.dart';
import 'package:music/domain/usecases/song/is_favorites_song.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerSingleton<AuthFirebaseService>(AuthFirebaseServiceImpl());
  sl.registerSingleton<SongFirebaseService>(SongFirebaseServiceImpl());

  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<SongsRepository>(SongRepositoryImpl());

  sl.registerSingleton<SignUpUseCase>(SignUpUseCase());
  sl.registerSingleton<SignInUseCase>(SignInUseCase());
  sl.registerSingleton<GetNewsSongUseCase>(GetNewsSongUseCase());
  sl.registerSingleton<GetPlaylistSongUsecase>(GetPlaylistSongUsecase());

  sl.registerSingleton<AddOrRemoveFavoritesSongUseCase>(
      AddOrRemoveFavoritesSongUseCase());
  sl.registerSingleton<IsFavoritesSongUseCase>(IsFavoritesSongUseCase());
  sl.registerSingleton<GetFavoriteSongUseCase>(GetFavoriteSongUseCase());
  sl.registerSingleton<GetUserUseCase>(GetUserUseCase());
}
