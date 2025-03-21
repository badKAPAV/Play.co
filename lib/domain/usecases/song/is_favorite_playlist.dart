import 'package:musify/core/usecase/usecase.dart';
import 'package:musify/domain/repository/song/song.dart';
import 'package:musify/service_locator.dart';

class IsFavoritePlaylistUseCase implements UseCase<bool, String> {
  @override
  Future<bool> call({String? params}) async {
    return await sl<SongsRepository>().isFavoritePlaylist(params!);
  }
}
