import 'package:music/domain/entities/song/song.dart';

class AppURLs {
  static const coversFireStorage =
      'https://firebasestorage.googleapis.com/v0/b/spotify0101.appspot.com/o/covers%2F';
  static const songsFireStorage =
      'https://firebasestorage.googleapis.com/v0/b/spotify0101.appspot.com/o/songs%2F';
  static const mediaAlt = 'alt=media';

  static String urlImage(SongEntity song) {
    return '${AppURLs.coversFireStorage}${Uri.encodeFull('${song.artist.replaceAll('\t', ' ').replaceAll(',', ' ,')} '
        '- ${song.title}')}.jpg?${AppURLs.mediaAlt}';
  }

  static String urlSong(SongEntity song) {
    return '${AppURLs.songsFireStorage}${Uri.encodeFull('${song.artist.replaceAll('\t', ' ').replaceAll(',', ' ,')} '
        '- ${song.title}')}.mp3?${AppURLs.mediaAlt}';
  }
}
