import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musify/common/helpers/is_dark_mode.dart';
import 'package:musify/common/widgets/favorite_button/favorite_button.dart';
import 'package:musify/core/config/constants/app_urls.dart';
import 'package:musify/core/config/theme/app_colors.dart';
import 'package:musify/domain/entities/song/song.dart';
import 'package:musify/presentation/home/bloc/playlist_cubit.dart';
import 'package:musify/presentation/home/bloc/playlist_state.dart';
import 'package:musify/presentation/song_player/bloc/song_player_cubit.dart';

class Playlist extends StatefulWidget {
  const Playlist({super.key});

  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (!mounted) return const SizedBox.shrink();

    return BlocProvider(
      create: (_) => PlaylistCubit()..getPlaylist(),
      child:
          BlocBuilder<PlaylistCubit, PlaylistState>(builder: (context, state) {
        if (state is PlaylistLoading) {
          _songsLoading();
        }
        if (state is PlaylistLoaded) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Just for You',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(
                      'See More',
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                _songs(state.songs),
                const SizedBox(
                  height: 80,
                ),
              ],
            ),
          );
        }
        return Container();
      }),
    );
  }

  Widget _songs(List<SongEntity> songs) {
    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        //scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Row(
            children: [
              // Container(
              //     height: 40,
              //     width: 40,
              //     decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       color: context.isDarkMode
              //           ? AppColors.darkGrey.withOpacity(1)
              //           : AppColors.lightGrey,
              //     ),
              //     child: Icon(
              //       Icons.play_arrow_rounded,
              //       color: context.isDarkMode
              //           ? AppColors.lightBackground
              //           : AppColors.darkGrey,
              //     )),
              // const SizedBox(
              //   width: 20,
              // ),
              GestureDetector(
                onTap: () {
                  context.read<SongPlayerCubit>().loadSong(
                      AppUrls.songFirestorage +
                          Uri.encodeComponent(songs[index].artist +
                              ' - ' +
                              songs[index].title +
                              '.mp3') +
                          '?' +
                          AppUrls.mediaAlt,
                      songs[index]);
                },
                child: Stack(alignment: Alignment.center, children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(
                          '${AppUrls.coverFirestorage}${songs[index].artist} - ${songs[index].title}.jpg?${AppUrls.mediaAlt}',
                        ))),
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black38),
                  ),
                  const Icon(
                    size: 30,
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                  )
                ]),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    songs[index].title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    songs[index].artist,
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
              FavoriteButton(songEntity: songs[index]),
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
            ],
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 15,
          );
        },
        itemCount: songs.length);
  }

  Widget _songsLoading() {
    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        //scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Row(
            children: [
              // Container(
              //     height: 40,
              //     width: 40,
              //     decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       color: context.isDarkMode
              //           ? AppColors.darkGrey.withOpacity(1)
              //           : AppColors.lightGrey,
              //     ),
              //     child: Icon(
              //       Icons.play_arrow_rounded,
              //       color: context.isDarkMode
              //           ? AppColors.lightBackground
              //           : AppColors.darkGrey,
              //     )),
              // const SizedBox(
              //   width: 20,
              // ),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: context.isDarkMode
                        ? AppColors.lightBackground
                        : AppColors.darkGrey),
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: context.isDarkMode
                            ? AppColors.lightBackground
                            : AppColors.darkGrey),
                  ),
                  Container(
                    height: 10,
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: context.isDarkMode
                            ? AppColors.lightBackground
                            : AppColors.darkGrey),
                  ),
                ],
              ),
            ],
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 20,
          );
        },
        itemCount: 5);
  }
}
