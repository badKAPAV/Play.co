import 'package:get_it/get_it.dart';
import 'package:musify/data/repository/auth/auth_repository_impl.dart';
import 'package:musify/data/repository/search/search_repository_impl.dart';
import 'package:musify/data/repository/song/song_repository_impl.dart';
import 'package:musify/data/sources/auth/auth_firebase_service.dart';
import 'package:musify/data/sources/search/search_firebase_service.dart';
import 'package:musify/data/sources/song/song_firebase_service.dart';
import 'package:musify/domain/repository/auth/auth.dart';
import 'package:musify/domain/repository/search/search.dart';
import 'package:musify/domain/repository/song/song.dart';
import 'package:musify/domain/usecases/auth/get_user.dart';
import 'package:musify/domain/usecases/auth/siginin.dart';
import 'package:musify/domain/usecases/auth/signup.dart';
import 'package:musify/domain/usecases/search/search_albums.dart';
import 'package:musify/domain/usecases/search/search_artists.dart';
import 'package:musify/domain/usecases/search/search_songs.dart';
import 'package:musify/domain/usecases/song/add_or_remove_favorites.dart';
import 'package:musify/domain/usecases/song/get_liked_songs.dart';
import 'package:musify/domain/usecases/song/get_new_songs.dart';
import 'package:musify/domain/usecases/song/get_playlist.dart';
import 'package:musify/domain/usecases/song/is_favorite.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerSingleton<AuthFirebaseService>(AuthFirebaseServiceImpl());

  sl.registerSingleton<SongFirebaseService>(SongFirebaseServiceImpl());

  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());

  sl.registerSingleton<SongsRepository>(
      SongRepositoryImpl(sl<SongFirebaseService>()));

  sl.registerSingleton<SignupUseCase>(SignupUseCase());

  sl.registerSingleton<SigninUseCase>(SigninUseCase());

  sl.registerSingleton<GetNewSongsUseCase>(GetNewSongsUseCase());

  sl.registerSingleton<GetPlaylistUseCase>(GetPlaylistUseCase());

  sl.registerSingleton<AddOrRemoveFavoritesUseCase>(
      AddOrRemoveFavoritesUseCase());

  sl.registerSingleton<IsFavoriteUseCase>(IsFavoriteUseCase());

  sl.registerSingleton<SearchRepository>(SearchRepositoryImpl());

  sl.registerLazySingleton<SearchFirebaseService>(
      () => SearchFirebaseServiceImpl());

  sl.registerSingleton<SearchSongsUseCase>(
      SearchSongsUseCase(sl<SearchRepository>()));

  sl.registerSingleton<SearchAlbumsUseCase>(SearchAlbumsUseCase());

  sl.registerSingleton<SearchArtistsUseCase>(
      SearchArtistsUseCase(sl<SearchRepository>()));

  sl.registerSingleton<GetUserUseCase>(GetUserUseCase());

  sl.registerSingleton<GetLikedSongsUseCase>(GetLikedSongsUseCase());
}
