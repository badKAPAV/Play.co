import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musify/common/helpers/is_dark_mode.dart';
import 'package:musify/common/widgets/appbar/app_bar.dart';
import 'package:musify/core/config/theme/app_colors.dart';
import 'package:musify/domain/usecases/search/search_artists.dart';
import 'package:musify/domain/usecases/search/search_songs.dart';
import 'package:musify/presentation/search/bloc/artist_search_cubit.dart';
import 'package:musify/presentation/search/bloc/song_search_cubit.dart';
import 'package:musify/presentation/search/widgets/results_albums.dart';
import 'package:musify/presentation/search/widgets/results_artists.dart';
import 'package:musify/presentation/search/widgets/results_songs.dart';
import 'package:musify/presentation/search/widgets/search_tabs.dart';
import 'package:musify/presentation/search/widgets/searching_bar.dart';
import 'package:musify/service_locator.dart';

class SearchPage extends StatefulWidget {
  SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return MultiBlocProvider(
        //create: (_) => SongSearchCubit(sl<SearchSongsUseCase>()),
        providers: [
          BlocProvider(
              create: (_) => SongSearchCubit(sl<SearchSongsUseCase>())),
          BlocProvider(
              create: (_) => ArtistSearchCubit(sl<SearchArtistsUseCase>())),
        ],
        child: Scaffold(
          backgroundColor: AppColors.darkBackground,
          appBar: BasicAppBar(
            appbarHeight: height / 6.5,
            hideBack: true,
            flexibleSpace: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: SearchingBar(controller: searchController),
                  ),
                  SearchTabs(controller: _tabController),
                ],
              ),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [ResultsSongs(), ResultsArtists(), ResultsAlbums()],
          ),
        ));
  }

  Widget _tabs() {
    return SizedBox(
      height: 60,
      child: TabBar(
        //tabAlignment: TabAlignment.start,
        splashFactory: NoSplash.splashFactory,
        dividerColor: Colors.transparent,
        controller: _tabController,
        //labelColor: context.isDarkMode ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 35),
        //indicatorColor: AppColors.primary,
        // indicatorWeight: 10,
        indicatorSize: TabBarIndicatorSize.label,
        indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            //border: Border.all(color: AppColors.primary, width: 2),
            color: AppColors.primary),
        unselectedLabelStyle: TextStyle(
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w300,
            fontSize: 14,
            color: context.isDarkMode
                ? AppColors.lightBackground
                : AppColors.darkBackground),
        labelStyle: const TextStyle(
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppColors.darkBackground),
        tabs: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'Songs',
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'Artists',
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'Albums',
            ),
          ),
        ],
      ),
    );
  }
}
