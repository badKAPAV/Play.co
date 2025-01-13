import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musify/domain/entities/song/song.dart';
import 'package:musify/presentation/song_player/bloc/song_player_state.dart';

class SongPlayerCubit extends Cubit<SongPlayerState> {
  AudioPlayer audioPlayer = AudioPlayer();

  SongEntity? currentSong;

  Duration songDuration = Duration.zero;
  Duration songPosition = Duration.zero;

  SongPlayerCubit() : super(SongPlayerInitial()) {
    audioPlayer.positionStream.listen((position) {
      songPosition = position;
      _updateSongPlayerState();
    });

    audioPlayer.durationStream.listen((duration) {
      songDuration = duration ?? Duration.zero;
      _updateSongPlayerState();
    });
  }

  // void updateSongPlayer() {
  //   emit(SongPlayerLoaded());
  // }

  Future<void> loadSong(String url, SongEntity song) async {
    emit(SongPlayerLoading());
    currentSong = song;
    try {
      await audioPlayer.setUrl(url);
      audioPlayer.play();
      _updateSongPlayerState();

      // emit(SongPlayerLoaded(song,
      //     position: songPosition, duration: songDuration, isPlaying: true));
    } catch (e) {
      emit(SongPlayerFailure());
    }
  }

  void playOrPauseSong() {
    if (audioPlayer.playing) {
      audioPlayer.pause();
    } else {
      audioPlayer.play();
    }

    _updateSongPlayerState();

    // emit(SongPlayerLoaded(
    //   currentSong!,
    //   position: songPosition,
    //   duration: songDuration,
    //   isPlaying: audioPlayer.playing,
    // ));
  }

  void _updateSongPlayerState() {
    if (currentSong != null) {
      emit(SongPlayerLoaded(currentSong!,
          position: songPosition,
          duration: songDuration,
          isPlaying: audioPlayer.playing));
    }
  }

  void seekTo(Duration position) {
    audioPlayer.seek(position);
  }

  @override
  Future<void> close() {
    audioPlayer.dispose();
    return super.close();
  }
}
