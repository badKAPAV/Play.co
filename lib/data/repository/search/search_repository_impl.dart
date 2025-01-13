import 'package:dartz/dartz.dart';
import 'package:musify/core/error/failures.dart';
import 'package:musify/data/sources/search/search_firebase_service.dart';
import 'package:musify/domain/entities/song/song.dart';
import 'package:musify/domain/repository/search/search.dart';
import 'package:musify/service_locator.dart';

class SearchRepositoryImpl extends SearchRepository {
  @override
  Future<Either<Failure, List<SongEntity>>> getAlbumSearchResult(
      String searchKey) async {
    return await sl<SearchFirebaseService>().getAlbumSearchResult(searchKey);
  }

  @override
  Future<Either<Failure, List<SongEntity>>> getArtistSearchResult(
      String searchKey) async {
    return await sl<SearchFirebaseService>().getArtistSearchResult(searchKey);
  }

  @override
  Future<Either<Failure, List<SongEntity>>> getSongSearchResult(
      String searchKey) async {
    return await sl<SearchFirebaseService>().getSongSearchResult(searchKey);
  }
}
