import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musify/common/helpers/is_dark_mode.dart';
import 'package:musify/core/config/constants/app_urls.dart';
import 'package:musify/core/config/theme/app_colors.dart';
import 'package:musify/domain/entities/song/song.dart';
import 'package:musify/presentation/search/bloc/artist_search_cubit.dart';
import 'package:musify/presentation/search/bloc/artist_search_state.dart';
import 'package:musify/presentation/song_player/bloc/song_player_cubit.dart';

class ResultsArtists extends StatelessWidget {
  const ResultsArtists({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArtistSearchCubit, ArtistSearchState>(
        builder: (context, state) {
      if (state is ArtistSearchLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is ArtistSearchEmpty) {
        return Center(
          child: Text(
            'Search for a song',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: context.isDarkMode ? Colors.white : Colors.black),
          ),
        );
      } else if (state is ArtistSearchIdle) {
        return Center(
          child: Text(
            'Search for an artist',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: context.isDarkMode ? Colors.white : Colors.black),
          ),
        );
      } else if (state is ArtistSearchError) {
        Center(
          child: Text(
            'An error occured. Please try again.',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: context.isDarkMode ? Colors.white : Colors.black),
          ),
        );
      } else if (state is ArtistSearchLoaded) {
        if (state.songs.isEmpty) {
          return Center(
            child: Text(
              'No songs found',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: context.isDarkMode ? Colors.white : Colors.black),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              _songs(state.songs),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      }
      return Container();
    });
  }

  Widget _songs(List<SongEntity> songs) {
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              context.read<SongPlayerCubit>().loadSong(
                  AppUrls.songFirestorage +
                      Uri.encodeComponent(songs[index].artist +
                          ' - ' +
                          songs[index].title +
                          '.' +
                          songs[index].fileType) +
                      '?' +
                      AppUrls.mediaAlt,
                  songs[index]);
            },
            child: Row(
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
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(
                        '${AppUrls.coverFirestorage}${songs[index].artist} - ${songs[index].title}.jpg?${AppUrls.mediaAlt}',
                      ))),
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
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.more_vert_rounded))
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 15,
          );
        },
        itemCount: songs.length);
  }
}
