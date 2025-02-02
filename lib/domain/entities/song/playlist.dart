import 'package:cloud_firestore/cloud_firestore.dart';

class PlaylistEntity {
  final String title;
  final String createdBy;
  final bool isFavorite;
  final String description;
  final Timestamp dateCreated;
  final String type;
  final String playlistId;

  PlaylistEntity(
      {required this.playlistId,
      required this.title,
      required this.type,
      required this.createdBy,
      required this.isFavorite,
      required this.description,
      required this.dateCreated});
}
