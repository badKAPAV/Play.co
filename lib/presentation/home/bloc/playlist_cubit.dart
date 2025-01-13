import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musify/domain/usecases/song/get_playlist.dart';
import 'package:musify/presentation/home/bloc/playlist_state.dart';
import 'package:musify/service_locator.dart';

class PlaylistCubit extends Cubit<PlaylistState> {
  PlaylistCubit() : super(PlaylistLoading());

  Future<void> getPlaylist() async {
    try {
      var returnedPlaylists = await sl<GetPlaylistUseCase>().call();

      if (isClosed) return;

      returnedPlaylists.fold(
        (l) {
          emit(PlaylistLoadFailure());
        },
        (data) {
          emit(PlaylistLoaded(songs: data));
        },
      );
    } catch (e) {
      if (!isClosed) emit(PlaylistLoadFailure());
    }
  }
}
