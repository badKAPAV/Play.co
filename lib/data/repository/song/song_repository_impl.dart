import 'package:dartz/dartz.dart';
import 'package:musify/data/sources/song/song_firebase_service.dart';
import 'package:musify/domain/entities/song/song.dart';
import 'package:musify/domain/repository/song/song.dart';

class SongRepositoryImpl extends SongsRepository {
  final SongFirebaseService _firebaseService;

  SongRepositoryImpl(this._firebaseService);

  @override
  Stream<List<SongEntity>> get songsStream => _firebaseService.songsStream;

  @override
  Future<Either> getNewSongs() async {
    return await _firebaseService.getNewSongs();
  }

  @override
  Future<Either> getPlaylist() async {
    return await _firebaseService.getPlaylist();
  }

  @override
  Future<Either> addOrRemoveFavorite(String songId) async {
    return await _firebaseService.addOrRemoveFavorite(songId);
  }

  @override
  Future<bool> isFavorite(String songId) async {
    return await _firebaseService.isFavorite(songId);
  }

  @override
  Future<Either> getUserLikedSongs() async {
    return await _firebaseService.getUserLikedSongs();
  }

  @override
  Future<Either> getPlaylistById(String playlistId) {
    // TODO: implement getPlaylistById
    throw UnimplementedError();
  }
}
