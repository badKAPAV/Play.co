import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:musify/core/error/failures.dart';
import 'package:musify/data/models/song/song.dart';
import 'package:musify/domain/entities/song/song.dart';
import 'package:musify/domain/usecases/song/is_favorite.dart';
import 'package:musify/service_locator.dart';

abstract class SearchFirebaseService {
  Future<Either<Failure, List<SongEntity>>> getSongSearchResult(
      String searchKey);
  Future<Either<Failure, List<SongEntity>>> getAlbumSearchResult(
      String searchKey);
  Future<Either<Failure, List<SongEntity>>> getArtistSearchResult(
      String searchKey);
}

class SearchFirebaseServiceImpl extends SearchFirebaseService {
  @override
  Future<Either<Failure, List<SongEntity>>> getSongSearchResult(
      String searchKey) async {
    try {
      List<SongEntity> songs = [];
      var result = await FirebaseFirestore.instance
          .collection('Songs')
          .orderBy('title')
          .startAt([searchKey]).endAt([searchKey + '\uf8ff']).get();

      for (var element in result.docs) {
        var songModel = SongModel.fromJson(element.data());
        bool isFavorite =
            await sl<IsFavoriteUseCase>().call(params: element.reference.id);
        songModel.isFavorite = isFavorite;
        songModel.songId = element.reference.id;
        songs.add(songModel.toEntity());
      }

      return Right(songs);
    } catch (e) {
      return Left(ServerFailure('An error occured. Please try again'));
    }
  }

  @override
  Future<Either<Failure, List<SongEntity>>> getAlbumSearchResult(
      String searchKey) {
    // TODO: implement getAlbumSearchResult
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<SongEntity>>> getArtistSearchResult(
      String searchKey) async {
    try {
      List<SongEntity> songs = [];
      var result = await FirebaseFirestore.instance
          .collection('Songs')
          .orderBy('artist')
          .startAt([searchKey]).endAt([searchKey + '\uf8ff']).get();

      for (var element in result.docs) {
        var songModel = SongModel.fromJson(element.data());
        bool isFavorite =
            await sl<IsFavoriteUseCase>().call(params: element.reference.id);
        songModel.isFavorite = isFavorite;
        songModel.songId = element.reference.id;
        songs.add(songModel.toEntity());
      }

      return Right(songs);
    } catch (e) {
      return Left(ServerFailure('An error occured. Please try again'));
    }
  }
}
