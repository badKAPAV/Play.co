import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:musify/data/models/song/song.dart';
import 'package:musify/domain/entities/song/song.dart';
import 'package:musify/domain/usecases/song/is_favorite.dart';
import 'package:musify/service_locator.dart';

abstract class SongFirebaseService {
  Stream<List<SongEntity>> get songsStream;
  Future<Either> getNewSongs();
  Future<Either> getPlaylist();
  Future<Either> addOrRemoveFavorite(String songId);
  Future<bool> isFavorite(String songId);
  Future<Either> getUserLikedSongs();
  Future<Either> getPlaylistById(String playlistId);
}

class SongFirebaseServiceImpl extends SongFirebaseService {
  @override
  Stream<List<SongEntity>> get songsStream {
    return FirebaseFirestore.instance
        .collection('Songs')
        .orderBy('releaseDate', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      List<SongEntity> songs = [];
      for (var doc in snapshot.docs) {
        var songModel = SongModel.fromJson(doc.data());
        bool isFavorite =
            await sl<IsFavoriteUseCase>().call(params: doc.reference.id);
        songModel.isFavorite = isFavorite;
        songModel.songId = doc.reference.id;
        songs.add(songModel.toEntity());
      }
      return songs;
    });
  }

  Future<Either> getNewSongs() async {
    try {
      List<SongEntity> songs = [];
      var data = await FirebaseFirestore.instance
          .collection('Songs')
          .orderBy('releaseDate', descending: true)
          .limit(5)
          .get();

      for (var element in data.docs) {
        var songModel = SongModel.fromJson(element.data());
        bool isFavorite =
            await sl<IsFavoriteUseCase>().call(params: element.reference.id);
        songModel.isFavorite = isFavorite;
        songModel.songId = element.reference.id;
        songs.add(songModel.toEntity());
      }

      return Right(songs);
    } catch (e) {
      return const Left('An error occured, Please try again');
    }
  }

  @override
  Future<Either> getPlaylist() async {
    try {
      List<SongEntity> songs = [];
      var data = await FirebaseFirestore.instance
          .collection('Songs')
          .orderBy('releaseDate', descending: true)
          .get();

      for (var element in data.docs) {
        var songModel = SongModel.fromJson(element.data());
        bool isFavorite =
            await sl<IsFavoriteUseCase>().call(params: element.reference.id);
        songModel.isFavorite = isFavorite;
        songModel.songId = element.reference.id;
        songs.add(songModel.toEntity());
      }

      return Right(songs);
    } catch (e) {
      return const Left('An error occured, Please try again');
    }
  }

  @override
  Future<Either> addOrRemoveFavorite(String songId) async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      late bool isFavorite;
      var user = firebaseAuth.currentUser;
      String uId = user!.uid;

      QuerySnapshot favoriteSong = await firebaseFirestore
          .collection('Users')
          .doc(uId)
          .collection('Favorites')
          .where('songId', isEqualTo: songId)
          .get();

      if (favoriteSong.docs.isNotEmpty) {
        await favoriteSong.docs.first.reference.delete();
        isFavorite = false;
      } else {
        await firebaseFirestore
            .collection('Users')
            .doc(uId)
            .collection('Favorites')
            .add({
          'songId': songId,
          'addedDate': Timestamp.now(),
        });
        isFavorite = true;
        print('firebase got updated');
      }
      return Right(isFavorite);
    } catch (e) {
      return const Left('An error occured');
    }
  }

  @override
  Future<bool> isFavorite(String songId) async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      var user = firebaseAuth.currentUser;
      String uId = user!.uid;

      QuerySnapshot favoriteSong = await firebaseFirestore
          .collection('Users')
          .doc(uId)
          .collection('Favorites')
          .where('songId', isEqualTo: songId)
          .get();

      if (favoriteSong.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Either> getUserLikedSongs() async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      List<SongEntity> favoriteSongs = [];
      var user = firebaseAuth.currentUser;
      String uId = user!.uid;

      QuerySnapshot favoritesSnapshot = await firebaseFirestore
          .collection('Users')
          .doc(uId)
          .collection('Favorites')
          .get();

      for (var element in favoritesSnapshot.docs) {
        String songId = element['songId'];
        var song =
            await firebaseFirestore.collection('Songs').doc(songId).get();
        var songModel = SongModel.fromJson(song.data()!);
        songModel.isFavorite = true;
        songModel.songId = songId;
        favoriteSongs.add(songModel.toEntity());
      }

      return Right(favoriteSongs);
    } catch (e) {
      return const Left('An error occured');
    }
  }

  @override
  Future<Either> getPlaylistById(String playlistId) {
    // TODO: implement getPlaylistById
    throw UnimplementedError();
  }
}
