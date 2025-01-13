import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musify/domain/usecases/search/search_songs.dart';
import 'package:musify/presentation/search/bloc/song_search_state.dart';
import 'package:rxdart/rxdart.dart';

class SongSearchCubit extends Cubit<SongSearchState> {
  final SearchSongsUseCase searchSongsUseCase;

  final _textInputController = BehaviorSubject<String>();

  SongSearchCubit(this.searchSongsUseCase) : super(SongSearchIdle()) {
    _textInputController
        .debounceTime(const Duration(milliseconds: 300))
        .listen((query) => _searchSongs(query));
  }

  void onTextChanged(String query) async {
    _textInputController.add(query);
  }

  Future<void> _searchSongs(String query) async {
    if (query.isEmpty) {
      emit(SongSearchIdle());
      return;
    }

    emit(SongSearchLoading());

    final result = await searchSongsUseCase(params: query);
    emit(result.fold((failure) => SongSearchError(),
        (songs) => SongSearchLoaded(songs: songs)));
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
