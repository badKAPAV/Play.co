import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musify/common/widgets/appbar/app_bar.dart';
import 'package:musify/common/widgets/favorite_button/favorite_button.dart';
import 'package:musify/core/config/constants/app_urls.dart';
import 'package:musify/presentation/profile/bloc/liked_songs_cubit.dart';
import 'package:musify/presentation/profile/bloc/liked_songs_state.dart';
import 'package:musify/presentation/profile/bloc/profile_info_cubit.dart';
import 'package:musify/presentation/profile/bloc/profile_info_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const BasicAppBar(),
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _profileInfo(context),
          const SizedBox(height: 20),
          //_playlists(context)
        ],
      ),
    );
  }

  Widget _profileInfo(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileInfoCubit()..getUser(),
      child: Container(
        height: MediaQuery.of(context).size.height / 3,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(20)),
        ),
        child: BlocBuilder<ProfileInfoCubit, ProfileInfoState>(
          builder: (context, state) {
            if (state is ProfileInfoLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ProfileInfoLoaded) {
              return Stack(
                children: [
                  ClipRRect(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(state.userEntity.imageUrl!)),
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 20,
                      left: 30,
                      child: Text(
                        state.userEntity.fullName!,
                        style: const TextStyle(
                            fontSize: 34, fontWeight: FontWeight.w900),
                      )),
                ],
              );
            }
            if (state is ProfileInfoFailure) {
              return const Center(child: Text('Error'));
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _playlists(BuildContext context) {
    return BlocProvider(
        create: (context) => LikedSongsCubit()..getLikedSongs(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Liked Songs',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            BlocBuilder<LikedSongsCubit, LikedSongsState>(
                builder: (context, state) {
              if (state is LikedSongsLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is LikedSongsLoaded) {
                return ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Stack(alignment: Alignment.center, children: [
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
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.likedSongs[index].title,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  state.likedSongs[index].artist,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                            const Spacer(),
                            FavoriteButton(songEntity: state.likedSongs[index]),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.more_vert))
                          ],
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
            }),
          ],
        ));
  }
}
