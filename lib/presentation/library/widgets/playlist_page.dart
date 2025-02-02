import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musify/common/helpers/is_dark_mode.dart';
import 'package:musify/common/widgets/appbar/app_bar.dart';
import 'package:musify/core/config/constants/app_urls.dart';
import 'package:musify/core/config/theme/app_colors.dart';
import 'package:musify/presentation/profile/bloc/liked_songs_cubit.dart';
import 'package:musify/presentation/profile/bloc/liked_songs_state.dart';
import 'package:musify/presentation/song_player/bloc/song_player_cubit.dart';

class PlaylistPage extends StatelessWidget {
  const PlaylistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      extendBodyBehindAppBar: true,
      appBar: const BasicAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            _playlistInfo(context),
            const SizedBox(height: 20),
            _playlist(context)
          ],
        ),
      ),
    );
  }
}

Widget _playlistInfo(BuildContext context) {
  return BlocProvider(
    create: (context) => LikedSongsCubit()..getLikedSongs(),
    child: Column(
      //crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: const DecorationImage(
                  image: CachedNetworkImageProvider(
                      'https://preview.redd.it/rnqa7yhv4il71.jpg?width=1080&crop=smart&auto=webp&s=de143a33b07bab0242ab488cbfe9145e152c01b9'))),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Liked Songs',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
        BlocBuilder<LikedSongsCubit, LikedSongsState>(
            builder: (context, state) {
          if (state is LikedSongsLoaded) {
            return Text(
              '${state.likedSongs.length} songs',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            );
          }
          return Container();
        }),
      ],
    ),
  );
}

Widget _playlist(BuildContext context) {
  return BlocProvider(
      create: (context) => LikedSongsCubit()..getLikedSongs(),
      child: BlocBuilder<LikedSongsCubit, LikedSongsState>(
          builder: (context, state) {
        if (state is LikedSongsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is LikedSongsLoaded) {
          return ListView.separated(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: GestureDetector(
                    onTap: () {
                      context.read<SongPlayerCubit>().loadSong(
                          AppUrls.songFirestorage +
                              Uri.encodeComponent(
                                  state.likedSongs[index].artist +
                                      ' - ' +
                                      state.likedSongs[index].title +
                                      '.' +
                                      state.likedSongs[index].fileType) +
                              '?' +
                              AppUrls.mediaAlt,
                          state.likedSongs[index]);
                    },
                    child: Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                '${AppUrls.coverFirestorage}${state.likedSongs[index].artist} - ${state.likedSongs[index].title}.jpg?${AppUrls.mediaAlt}',
                              ))),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.likedSongs[index].title,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              state.likedSongs[index].artist,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: context.isDarkMode
                                      ? AppColors.darkModeTextSecondary
                                      : AppColors.lightModeTextSecondary),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.more_vert))
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 10,
                );
              },
              itemCount: state.likedSongs.length);
        }
        return Container();
      }));
}
