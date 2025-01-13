import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:musify/common/bloc/auth/auth_cubit.dart';
import 'package:musify/common/bloc/auth/auth_state.dart';
import 'package:musify/common/helpers/is_dark_mode.dart';
import 'package:musify/common/widgets/appbar/app_bar.dart';
import 'package:musify/core/config/assets/app_vectors.dart';
import 'package:musify/core/config/theme/app_colors.dart';
import 'package:musify/domain/entities/auth/user.dart';
import 'package:musify/presentation/home/pages/home_nav.dart';
import 'package:musify/presentation/library/widgets/playlist_page.dart';
import 'package:musify/presentation/profile/bloc/liked_songs_cubit.dart';
import 'package:musify/presentation/profile/bloc/liked_songs_state.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: BasicAppBar(
            hideBack: true,
            leading: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                //final UserEntity? user = state.user;
                return IconButton(
                  onPressed: () {
                    HomeNavPage.scaffoldKey.currentState?.openDrawer();
                  },
                  icon: Icon(
                    Icons.menu_rounded,
                    color: context.isDarkMode ? Colors.white : Colors.black,
                  ),
                );
              },
            ),
            // action: IconButton(
            //     onPressed: () {
            //       Navigator.of(context)
            //           .push(MaterialPageRoute(builder: (_) => const ProfilePage()));
            //     },
            //     icon: const Icon(Icons.person_rounded)),
            title: const Text(
              'Your Collections',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
        body: _likedSongs(context));
  }
}

Widget _likedSongs(BuildContext context) {
  return BlocProvider(
    create: (context) => LikedSongsCubit()..getLikedSongs(),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/playlistPage');
            },
            child: Row(
              children: [
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              'https://preview.redd.it/rnqa7yhv4il71.jpg?width=1080&crop=smart&auto=webp&s=de143a33b07bab0242ab488cbfe9145e152c01b9'))),
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Liked Songs',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    BlocBuilder<LikedSongsCubit, LikedSongsState>(
                        builder: (context, state) {
                      if (state is LikedSongsLoaded) {
                        return Text(
                          '${state.likedSongs.length} songs',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        );
                      }
                      return Container();
                    }),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
