import 'package:dartz/dartz.dart';
import 'package:musify/domain/entities/song/song.dart';

abstract class SongsRepository {
  Stream<List<SongEntity>> get songsStream;
  Future<Either> getNewSongs();
  Future<Either> getPlaylist();
  Future<Either> addOrRemoveFavorite(String songId);
  Future<bool> isFavorite(String songId);
  Future<Either> getUserLikedSongs();

  Future<Either> getPlaylistById(String playlistId);
}
