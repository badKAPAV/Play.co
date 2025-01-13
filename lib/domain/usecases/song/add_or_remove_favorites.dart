import 'package:dartz/dartz.dart';
import 'package:musify/core/usecase/usecase.dart';
import 'package:musify/domain/repository/song/song.dart';
import 'package:musify/service_locator.dart';

class AddOrRemoveFavoritesUseCase implements UseCase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return await sl<SongsRepository>().addOrRemoveFavorite(params!);
  }
}
