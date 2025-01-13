import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musify/common/bloc/favorite_button/favorite_button_state.dart';
import 'package:musify/domain/usecases/song/add_or_remove_favorites.dart';
import 'package:musify/service_locator.dart';

class FavoriteButtonCubit extends Cubit<FavoriteButtonState> {
  FavoriteButtonCubit() : super(FavoriteButtonInitial());

  Future<void> favoriteButtonUpdated(String songId) async {
    var result = await sl<AddOrRemoveFavoritesUseCase>().call(params: songId);

    result.fold((l) {}, (isFavorite) {
      emit(FavoriteButtonUpdated(isFavorite: isFavorite));
    });
  }
}
