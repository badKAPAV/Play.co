import 'package:equatable/equatable.dart';
import 'package:musify/domain/entities/auth/user.dart';
import 'package:musify/domain/entities/song/song.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<SongEntity> newSongs;
  final UserEntity userEntity;

  const HomeLoaded({
    required this.newSongs,
    required this.userEntity,
  });

  @override
  List<Object?> get props => [newSongs, userEntity];

  HomeLoaded copyWith({
    List<SongEntity>? newSongs,
    UserEntity? userEntity,
  }) {
    return HomeLoaded(
      newSongs: newSongs ?? this.newSongs,
      userEntity: userEntity ?? this.userEntity,
    );
  }
}

class HomeError extends HomeState {}
