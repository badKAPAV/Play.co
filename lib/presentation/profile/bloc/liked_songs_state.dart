import 'package:musify/domain/entities/song/song.dart';

abstract class LikedSongsState {}

class LikedSongsInitial extends LikedSongsState {}

class LikedSongsLoading extends LikedSongsState {}

class LikedSongsLoaded extends LikedSongsState {
  final List<SongEntity> likedSongs;
  LikedSongsLoaded({required this.likedSongs});
}

class LikedSongsError extends LikedSongsState {}
