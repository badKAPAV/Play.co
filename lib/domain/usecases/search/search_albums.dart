import 'package:dartz/dartz.dart';
import 'package:musify/core/usecase/usecase.dart';
import 'package:musify/domain/repository/search/search.dart';
import 'package:musify/service_locator.dart';

class SearchAlbumsUseCase implements UseCase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return await sl<SearchRepository>().getAlbumSearchResult(params!);
  }
}
