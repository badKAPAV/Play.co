import 'package:equatable/equatable.dart';
import 'package:musify/domain/entities/song/song.dart';

abstract class SongPlayerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SongPlayerInitial extends SongPlayerState {}

class SongPlayerLoading extends SongPlayerState {}

class SongPlayerLoaded extends SongPlayerState {
  final SongEntity songEntity;
  final Duration position;
  final Duration duration;
  final bool isPlaying;

  SongPlayerLoaded(this.songEntity,
      {required this.position, required this.duration, this.isPlaying = true});

  @override
  List<Object?> get props => [songEntity, position, duration, isPlaying];
}

class SongPlayerFailure extends SongPlayerState {}

class SongPlayerNoSongSelected extends SongPlayerState {}
