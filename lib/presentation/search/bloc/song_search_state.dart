import 'package:musify/domain/entities/song/song.dart';

abstract class SongSearchState {}

class SongSearchIdle extends SongSearchState {}

class SongSearchLoading extends SongSearchState {}

class SongSearchLoaded extends SongSearchState {
  final List<SongEntity> songs;

  SongSearchLoaded({required this.songs});
}

class SongSearchError extends SongSearchState {}

class SongSearchEmpty extends SongSearchState {}
