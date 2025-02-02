import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:musify/domain/entities/song/song.dart';

class SongModel {
  String? title;
  String? artist;
  num? duration;
  Timestamp? releaseDate;
  bool? isFavorite;
  String? fileType;
  String? songId;

  SongModel(
      {required this.title,
      required this.artist,
      required this.duration,
      required this.releaseDate,
      required this.isFavorite,
      required this.fileType,
      required this.songId});

  SongModel.fromJson(Map<String, dynamic> data) {
    title = data['title'];
    artist = data['artist'];
    duration = data['duration'];
    releaseDate = data['releaseDate'];
    isFavorite = data['isFavorite'];
    songId = data['songId'];
    fileType = data['fileType'];
  }
}

extension SongModelX on SongModel {
  SongEntity toEntity() {
    return SongEntity(
      isFavorite: isFavorite!,
      title: title!,
      artist: artist!,
      duration: duration!,
      releaseDate: releaseDate!,
      songId: songId!,
      fileType: fileType!,
    );
  }
}
