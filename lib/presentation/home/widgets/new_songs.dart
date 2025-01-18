import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musify/common/helpers/is_dark_mode.dart';
import 'package:musify/core/config/constants/app_urls.dart';
import 'package:musify/core/config/theme/app_colors.dart';
import 'package:musify/domain/entities/song/song.dart';
import 'package:musify/presentation/home/bloc/new_songs_cubit.dart';
import 'package:musify/presentation/home/bloc/new_songs_state.dart';
import 'package:musify/presentation/song_player/bloc/song_player_cubit.dart';

class NewSongs extends StatefulWidget {
  const NewSongs({super.key});

  @override
  _NewSongsState createState() => _NewSongsState();
}

class _NewSongsState extends State<NewSongs>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (!mounted) return const SizedBox.shrink();

    return BlocProvider(
      create: (_) => NewSongsCubit()..getNewSongs(),
      child: SizedBox(
          height: 200,
          child: BlocBuilder<NewSongsCubit, NewSongsState>(
            builder: (context, state) {
              if (state is NewSongsLoading) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      _songsLoading(),
                      const SizedBox(
                        width: 15,
                      )
                    ],
                  ),
                );
              }
              if (state is NewSongsLoaded) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      _songs(state.songs),
                      const SizedBox(
                        width: 15,
                      )
                    ],
                  ),
                );
              }

              return Container();
            },
          )),
    );
  }

  Widget _songs(List<SongEntity> songs) {
    return ListView.separated(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return GestureDetector(
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
            child: SizedBox(
              width: 160,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                '${AppUrls.coverFirestorage}${songs[index].artist} - ${songs[index].title}.jpg?${AppUrls.mediaAlt}',
                              ))),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                            height: 40,
                            width: 40,
                            transform: Matrix4.translationValues(-5, 12, 0),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.grey),
                              shape: BoxShape.circle,
                              color: context.isDarkMode
                                  ? AppColors.darkGrey.withOpacity(1)
                                  : AppColors.lightGrey,
                            ),
                            child: Icon(
                              Icons.play_arrow_rounded,
                              color: context.isDarkMode
                                  ? AppColors.lightBackground
                                  : AppColors.darkGrey,
                            )),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      songs[index].title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      songs[index].artist,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: context.isDarkMode
                              ? AppColors.darkModeTextSecondary
                              : AppColors.lightModeTextSecondary),
                    ),
                  )
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(
            width: 14,
          );
        },
        itemCount: songs.length);
  }

  Widget _songsLoading() {
    return ListView.separated(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return SizedBox(
            width: 160,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: context.isDarkMode
                            ? AppColors.darkGrey
                            : AppColors.lightGrey),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: context.isDarkMode
                          ? AppColors.darkGrey
                          : AppColors.lightGrey,
                    ),
                    height: 16,
                    width: 100,
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: context.isDarkMode
                          ? AppColors.darkGrey
                          : AppColors.lightGrey,
                    ),
                    height: 10,
                    width: 50,
                  ),
                )
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            width: 14,
          );
        },
        itemCount: 3);
  }
}
