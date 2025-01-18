import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musify/common/bloc/auth/auth_cubit.dart';
import 'package:musify/common/bloc/bottom_nav_bar/bottom_navigation_cubit.dart';
import 'package:musify/common/bloc/home/home_cubit.dart';
import 'package:musify/common/helpers/is_dark_mode.dart';
import 'package:musify/core/config/theme/app_colors.dart';
import 'package:musify/data/sources/auth/auth_firebase_service.dart';
import 'package:musify/domain/repository/song/song.dart';
import 'package:musify/presentation/choose_mode/bloc/theme_cubit.dart';
import 'package:musify/presentation/home/pages/home.dart';
import 'package:musify/presentation/library/navigation/library_navigation.dart';
import 'package:musify/presentation/library/pages/library.dart';
import 'package:musify/presentation/profile/navigation/profile_navigation.dart';
import 'package:musify/presentation/profile/pages/profile.dart';
import 'package:musify/presentation/search/pages/search.dart';
import 'package:musify/presentation/song_player/bloc/song_player_cubit.dart';
import 'package:musify/presentation/song_player/bloc/song_player_state.dart';
import 'package:musify/presentation/song_player/widgets/miniplayer.dart';

class HomeNavPage extends StatelessWidget {
  const HomeNavPage({super.key});

  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BottomNavigationCubit(),
        ),
        //BlocProvider(create: (context) => SongPlayerCubit()),
        BlocProvider(
          create: (context) => HomeCubit(
            songRepository: context.read<SongsRepository>(),
          )..loadHomeData(),
        ),
      ],
      child: BottomNavBar(),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  BottomNavBar({super.key});

  final List<Widget> _screens = [
    // Builder(builder: (context) => const ProfileNavigation()),
    ProfileNavigation(),
    SearchPage(),
    LibraryNavigation(),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.8;
    return Scaffold(
      key: HomeNavPage.scaffoldKey,
      drawer: Drawer(
        width: width,
        backgroundColor: context.isDarkMode ? AppColors.darkGrey : Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    context.read<BottomNavigationCubit>().updateTabIndex(0);
                    Future.delayed(const Duration(milliseconds: 100), () {
                      ProfileNavigation.navigatorKey.currentState?.push(
                        MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ),
                      );
                    });
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.person_rounded,
                        size: 26,
                      ),
                      SizedBox(width: 20),
                      Text(
                        'View my profile',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    await context.read<AuthCubit>().signOut();
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.logout_rounded,
                        size: 26,
                      ),
                      SizedBox(width: 20),
                      Text(
                        'Log Out',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Colors.red),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: context.isDarkMode
                          ? AppColors.darkBackground
                          : AppColors.grey),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        const Text('Dark Mode',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Switch(
                          value: context.isDarkMode,
                          onChanged: (bool value) {
                            context.read<ThemeCubit>().updateTheme(
                                value ? ThemeMode.dark : ThemeMode.light);
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: Stack(children: [
        BlocBuilder<BottomNavigationCubit, int>(
            builder: (context, currentIndex) {
          return IndexedStack(
            index: currentIndex,
            children: _screens,
          );
        }),
        Positioned(
            left: 0,
            right: 0,
            bottom: 3,
            child: BlocBuilder<SongPlayerCubit, SongPlayerState>(
                builder: (context, state) {
              if (state is SongPlayerLoaded) {
                return Miniplayer(songEntity: state.songEntity);
              }
              return const SizedBox.shrink();
            }))
      ]),
      bottomNavigationBar: BlocBuilder<BottomNavigationCubit, int>(
          builder: (context, currentIndex) {
        return NavigationBar(
          backgroundColor:
              context.isDarkMode ? AppColors.darkBackground : Colors.white,
          //selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          //selectedItemColor:
          //    context.isDarkMode ? AppColors.lightGrey : AppColors.darkGrey,
          //type: BottomNavigationBarType.fixed,
          destinations: const <NavigationDestination>[
            NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Home'),
            NavigationDestination(
                icon: Icon(Icons.search_outlined),
                selectedIcon: Icon(Icons.search_rounded),
                label: 'Browse'),
            NavigationDestination(
                icon: Icon(Icons.library_books_outlined),
                selectedIcon: Icon(Icons.library_books_rounded),
                label: 'Collections'),
          ],
          selectedIndex: currentIndex,
          onDestinationSelected: (index) =>
              context.read<BottomNavigationCubit>().updateTabIndex(index),
        );
      }),
    );
  }
}
