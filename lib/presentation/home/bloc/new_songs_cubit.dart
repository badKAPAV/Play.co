import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musify/domain/usecases/song/get_new_songs.dart';
import 'package:musify/presentation/home/bloc/new_songs_state.dart';
import 'package:musify/service_locator.dart';

class NewSongsCubit extends Cubit<NewSongsState> {
  NewSongsCubit() : super(NewSongsLoading());

  Future<void> getNewSongs() async {
    try {
      var returnedSongs = await sl<GetNewSongsUseCase>().call();

      if (isClosed) return;

      returnedSongs.fold((l) {
        emit(NewSongsLoadFailure());
      }, (data) {
        emit(NewSongsLoaded(songs: data));
      });
    } catch (e) {
      if (!isClosed) emit(NewSongsLoadFailure());
    }
  }

  // @override
  // Future<void> close() {
  //   // Cancel any ongoing operations here
  //   _subscription?.cancel();
  //   return super.close();
  // }
}
