import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:musify/core/config/constants/app_urls.dart';
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
      final audioSource = AudioSource.uri(
        Uri.parse(url),
        tag: MediaItem(
          id: song.songId, // A unique ID for the song
          album: 'Unknown Album',
          title: song.title,
          artist: song.artist,
          artUri: Uri.parse(
              '${AppUrls.coverFirestorage}${song.artist} - ${song.title}.jpg?${AppUrls.mediaAlt}'), // Song artwork URL
        ),
      );

      await audioPlayer.setAudioSource(audioSource);
      audioPlayer.play();
      _updateSongPlayerState();

      // await audioPlayer.setUrl(url);
      // audioPlayer.play();
      // _updateSongPlayerState();
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
