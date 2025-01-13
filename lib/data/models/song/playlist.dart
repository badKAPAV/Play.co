import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:musify/domain/entities/song/playlist.dart';

class PlaylistModel {
  String? playlistId;
  String? title;
  String? createdBy;
  Timestamp? dateCreated;
  String? description;
  bool? isFavorite;

  PlaylistModel(
      {required this.playlistId,
      required this.createdBy,
      required this.title,
      required this.dateCreated,
      required this.isFavorite,
      required this.description});

  PlaylistModel.fromJson(Map<String, dynamic> data) {
    playlistId = data['playlistId'];
    title = data['title'];
    createdBy = data['createdBy'];
    dateCreated = data['dateCreated'];
    description = data['description'];
    isFavorite = data['isFavorite'];
  }
}

extension PlaylistModelX on PlaylistModel {
  PlaylistEntity toEntity() {
    return PlaylistEntity(
      playlistId: playlistId!,
      title: title!,
      createdBy: createdBy!,
      dateCreated: dateCreated!,
      description: description!,
      isFavorite: isFavorite!,
    );
  }
}
