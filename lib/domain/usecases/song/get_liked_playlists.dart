import 'package:dartz/dartz.dart';
import 'package:musify/core/usecase/usecase.dart';
import 'package:musify/domain/repository/song/song.dart';
import 'package:musify/service_locator.dart';

class GetLikedPlaylistsUseCase implements UseCase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return await sl<SongsRepository>().getLikedPlaylists();
  }
}
