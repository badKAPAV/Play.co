import 'package:musify/domain/entities/song/song.dart';

abstract class ArtistSearchState {}

class ArtistSearchIdle extends ArtistSearchState {}

class ArtistSearchLoading extends ArtistSearchState {}

class ArtistSearchLoaded extends ArtistSearchState {
  final List<SongEntity> songs;

  ArtistSearchLoaded({required this.songs});
}

class ArtistSearchError extends ArtistSearchState {}

class ArtistSearchEmpty extends ArtistSearchState {}
