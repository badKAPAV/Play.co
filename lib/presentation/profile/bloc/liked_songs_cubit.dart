import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musify/domain/entities/song/song.dart';
import 'package:musify/domain/usecases/song/get_liked_songs.dart';
import 'package:musify/presentation/profile/bloc/liked_songs_state.dart';
import 'package:musify/service_locator.dart';

class LikedSongsCubit extends Cubit<LikedSongsState> {
  LikedSongsCubit() : super(LikedSongsInitial());

  List<SongEntity> likedSongs = [];

  Future<void> getLikedSongs() async {
    var result = await sl<GetLikedSongsUseCase>().call();

    result.fold((l) {
      emit(LikedSongsError());
    }, (r) {
      likedSongs = r;
      emit(LikedSongsLoaded(likedSongs: likedSongs));
    });
  }
}
