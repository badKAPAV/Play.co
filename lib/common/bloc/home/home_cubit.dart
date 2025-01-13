import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musify/common/bloc/home/home_state.dart';
import 'package:musify/domain/repository/song/song.dart';
import 'package:musify/domain/usecases/auth/get_user.dart';
import 'package:musify/service_locator.dart';

class HomeCubit extends Cubit<HomeState> {
  final SongsRepository songRepository;
  StreamSubscription? _songsSubscription;

  HomeCubit({
    required this.songRepository,
  }) : super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(HomeLoading());
    try {
      final user = await sl<GetUserUseCase>().call();

      // Cancel existing subscription if any
      await _songsSubscription?.cancel();

      // Listen to song collection changes
      _songsSubscription = songRepository.songsStream.listen(
        (songs) {
          final userEntity = user.fold((l) {
            emit(HomeError());
            throw l;
          }, (r) => r);
          emit(HomeLoaded(newSongs: songs, userEntity: userEntity));
        },
        onError: (error) {
          emit(HomeError());
        },
      );
    } catch (e) {
      emit(HomeError());
    }
  }

  @override
  Future<void> close() {
    _songsSubscription?.cancel();
    return super.close();
  }
}
