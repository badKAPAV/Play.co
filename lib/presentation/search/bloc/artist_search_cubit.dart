import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musify/domain/usecases/search/search_artists.dart';
import 'package:musify/presentation/search/bloc/artist_search_state.dart';
import 'package:rxdart/rxdart.dart';

class ArtistSearchCubit extends Cubit<ArtistSearchState> {
  final SearchArtistsUseCase searchArtistsUseCase;

  final _textInputController = BehaviorSubject<String>();

  ArtistSearchCubit(this.searchArtistsUseCase) : super(ArtistSearchIdle()) {
    _textInputController
        .debounceTime(const Duration(milliseconds: 300))
        .listen((query) => _searchSongs(query));
  }

  void onTextChanged(String query) async {
    _textInputController.add(query);
  }

  Future<void> _searchSongs(String query) async {
    if (query.isEmpty) {
      emit(ArtistSearchIdle());
      return;
    }

    emit(ArtistSearchLoading());

    final result = await searchArtistsUseCase(params: query);
    emit(result.fold((failure) => ArtistSearchError(),
        (songs) => ArtistSearchLoaded(songs: songs)));
  }

  @override
  Future<void> close() {
    _textInputController.close();
    return super.close();
  }

  // Future<void> getSongSearchResult(String searchKey) async {
  //   var returnedSongs = await sl<GetNewSongsUseCase>().call(params: searchKey);

  //   returnedSongs.fold((l) {
  //     emit(SongSearchLoading());
  //   }, (data) {
  //   emit(SongSearchLoaded(songs: data));
  //   });
  // }
}
