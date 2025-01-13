import 'package:dartz/dartz.dart';
import 'package:musify/core/error/failures.dart';
import 'package:musify/domain/entities/song/song.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<SongEntity>>> getSongSearchResult(
      String searchKey);
  Future<Either<Failure, List<SongEntity>>> getArtistSearchResult(
      String searchKey);
  Future<Either<Failure, List<SongEntity>>> getAlbumSearchResult(
      String searchKey);
}
