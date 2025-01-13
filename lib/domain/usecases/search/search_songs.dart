import 'package:dartz/dartz.dart';
import 'package:musify/core/error/failures.dart';
import 'package:musify/core/usecase/usecase.dart';
import 'package:musify/domain/entities/song/song.dart';
import 'package:musify/domain/repository/search/search.dart';

class SearchSongsUseCase
    implements UseCase<Either<Failure, List<SongEntity>>, String> {
  final SearchRepository repository;

  SearchSongsUseCase(this.repository);

  @override
  Future<Either<Failure, List<SongEntity>>> call({String? params}) async {
    if (params == null || params.isEmpty) {
      return Left(InvalidInputFailure("Query cannot be empty"));
    }
    return await repository.getSongSearchResult(params);
  }
}
