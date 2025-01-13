import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musify/common/helpers/is_dark_mode.dart';
import 'package:musify/common/widgets/appbar/app_bar.dart';
//import 'package:musify/common/widgets/favorite_button/favorite_button.dart';
import 'package:musify/common/widgets/favorite_button/favorite_button_large.dart';
import 'package:musify/core/config/constants/app_urls.dart';
import 'package:musify/core/config/theme/app_colors.dart';
import 'package:musify/domain/entities/song/song.dart';
import 'package:musify/presentation/song_player/bloc/song_player_cubit.dart';
import 'package:musify/presentation/song_player/bloc/song_player_state.dart';
import 'package:palette_generator/palette_generator.dart';

class Miniplayer extends StatefulWidget {
  final SongEntity songEntity;

  const Miniplayer({super.key, required this.songEntity});

  @override
  State<Miniplayer> createState() => _MiniplayerState();
}

class _MiniplayerState extends State<Miniplayer> {
  Color? dominantColor;

  @override
  void initState() {
    super.initState();
    extractDominantColor();
  }

  @override
  void didUpdateWidget(Miniplayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.songEntity != widget.songEntity) {
      extractDominantColor();
    }
  }

  Future<void> extractDominantColor() async {
    final paletteGenerator = await PaletteGenerator.fromImageProvider(
      NetworkImage(
          '${AppUrls.coverFirestorage}${widget.songEntity.artist} - ${widget.songEntity.title}.jpg?${AppUrls.mediaAlt}'),
    );

    final color = paletteGenerator.dominantColor?.color ?? AppColors.primary;

    setState(() {
      dominantColor = adjustBrightness(color);
    });
  }

  Color adjustBrightness(Color color) {
    final hsl = HSLColor.fromColor(color);

    if (context.isDarkMode) {
      // In dark mode, ensure color isn't too bright
      return hsl.lightness > 0.3
          ? hsl.withLightness(0.3).toColor()
          : hsl.toColor();
    } else {
      // In light mode, ensure color isn't too dark
      return hsl.lightness < 0.5
          ? hsl.withLightness(0.5).toColor()
          : hsl.toColor();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(
        begin: dominantColor ?? AppColors.primary,
        end: dominantColor ?? AppColors.primary,
      ),
      duration: const Duration(milliseconds: 300),
      builder: (context, color, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => _songPlayerPage(context)));
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      color: color?.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10)),
                  child: BlocBuilder<SongPlayerCubit, SongPlayerState>(
                      builder: (context, state) {
                    if (state is SongPlayerLoading) {
                      return _miniplayerLoading(context);
                    } else if (state is SongPlayerLoaded) {
                      final songPlayerCubit = context.read<SongPlayerCubit>();
                      return _miniplayerLoaded(
                          songPlayerCubit, context, widget.songEntity);
                    }
                    return const SizedBox.shrink();
                  }),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _miniplayerLoaded(SongPlayerCubit songPlayerCubit,
      BuildContext context, SongEntity? currentSong) {
    return Row(
      children: [
        const SizedBox(
          width: 10,
        ),
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
          height: 45,
          width: 45,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  image: CachedNetworkImageProvider(
                '${AppUrls.coverFirestorage}${widget.songEntity.artist} - ${widget.songEntity.title}.jpg?${AppUrls.mediaAlt}',
              ))),
        ),
        const SizedBox(
          width: 15,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.songEntity.title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: context.isDarkMode ? Colors.white : Colors.black),
            ),
            Text(
              widget.songEntity.artist,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: context.isDarkMode ? Colors.white54 : Colors.black54),
            ),
          ],
        ),
        const Spacer(),
        FavoriteButtonLarge(songEntity: widget.songEntity),
        IconButton(
            onPressed: () {
              context.read<SongPlayerCubit>().playOrPauseSong();
            },
            icon: Icon(
              context.read<SongPlayerCubit>().audioPlayer.playing
                  ? Icons.pause_rounded
                  : Icons.play_arrow_rounded,
              size: 30,
              color: context.isDarkMode ? Colors.white : Colors.black,
            )),
        const SizedBox(
          width: 10,
        )
      ],
    );
  }

  Widget _miniplayerLoading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
          height: 60,
          decoration: BoxDecoration(
              color:
                  context.isDarkMode ? AppColors.darkGrey : AppColors.lightGrey,
              borderRadius: BorderRadius.circular(10)),
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
          )),
    );
  }

  Widget _songPlayerPage(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: const Text('Now Playing',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        action: IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 40,
            ),
            _songCover(context),
            const SizedBox(
              height: 50,
            ),
            _songDetails(context),
            const SizedBox(
              height: 10,
            ),
            _songPlayer(context),
          ],
        ),
      ),
    );
  }

  Widget _songCover(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0, top: 25, bottom: 20),
      child: Container(
        height: MediaQuery.of(context).size.width - 60,
        width: MediaQuery.of(context).size.width - 60,
        //width: MediaQuery.of(context).size.width - 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(
                  '${AppUrls.coverFirestorage}${widget.songEntity.artist} - ${widget.songEntity.title}.jpg?${AppUrls.mediaAlt}',
                ))),
      ),
    );
  }

  Widget _songDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.songEntity.title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.songEntity.artist,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.normal),
              ),
            ],
          ),
          const Spacer(),
          FavoriteButtonLarge(songEntity: widget.songEntity)
        ],
      ),
    );
  }

  Widget _songPlayer(BuildContext context) {
    final songPlayerCubit = context.read<SongPlayerCubit>();
    return StreamBuilder<Duration>(
      stream: songPlayerCubit.audioPlayer.positionStream,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 6),
                  thumbColor: context.isDarkMode ? Colors.white : Colors.black,
                  trackHeight: 2,
                  activeTrackColor:
                      context.isDarkMode ? Colors.white : Colors.black,
                ),
                child: Slider(
                  value: songPlayerCubit.songPosition.inSeconds.toDouble(),
                  onChanged: (value) {
                    songPlayerCubit.seekTo(Duration(seconds: value.toInt()));
                  },
                  min: 0.0,
                  max: songPlayerCubit.songDuration.inSeconds.toDouble(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatDuration(songPlayerCubit.songPosition),
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      formatDuration(songPlayerCubit.songDuration),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  songPlayerCubit.playOrPauseSong();
                },
                child: Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.isDarkMode ? Colors.white : Colors.black,
                  ),
                  child: Icon(
                    songPlayerCubit.audioPlayer.playing
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    size: 40,
                    color: context.isDarkMode ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

// class SongPlayerPage extends StatelessWidget {
//   final SongEntity songEntity;
//   const SongPlayerPage({super.key, required this.songEntity});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: BasicAppBar(
//         title: const Text('Now Playing',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         action: IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const SizedBox(
//               height: 40,
//             ),
//             _songCover(context),
//             const SizedBox(
//               height: 50,
//             ),
//             _songDetails(context),
//             const SizedBox(
//               height: 10,
//             ),
//             _songPlayer(context),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _songCover(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 0, right: 0, top: 25, bottom: 20),
//       child: Container(
//         height: MediaQuery.of(context).size.width - 60,
//         width: MediaQuery.of(context).size.width - 60,
//         //width: MediaQuery.of(context).size.width - 60,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(30),
//             image: DecorationImage(
//                 fit: BoxFit.cover,
//                 image: CachedNetworkImageProvider(
//                   '${AppUrls.coverFirestorage}${songEntity.artist} - ${songEntity.title}.jpg?${AppUrls.mediaAlt}',
//                 ))),
//       ),
//     );
//   }

//   Widget _songDetails(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
//       child: Row(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 songEntity.title,
//                 style:
//                     const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 songEntity.artist,
//                 style: const TextStyle(
//                     fontSize: 16, fontWeight: FontWeight.normal),
//               ),
//             ],
//           ),
//           const Spacer(),
//           FavoriteButton(songEntity: songEntity)
//         ],
//       ),
//     );
//   }

//   Widget _songPlayer(SongPlayerCubit songPlayerCubit, BuildContext context,
//       SongEntity? currentSong) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 5),
//       child: Container(
//         color: Colors.green.withOpacity(0.2),
//         child: Column(
//           children: [
//             SliderTheme(
//               data: SliderTheme.of(context).copyWith(
//                 thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
//                 thumbColor: Colors.white,
//                 trackHeight: 6,
//                 activeTrackColor: AppColors.lightPrimary,
//               ),
//               child: Slider(
//                 value: state.position.inSeconds.toDouble(),
//                 onChanged: (value) {
//                   context
//                       .read<SongPlayerCubit>()
//                       .seekTo(Duration(seconds: value.toInt()));
//                 },
//                 min: 0.0,
//                 max: state.duration.inSeconds.toDouble(),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 25),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     formatDuration(state.position),
//                     style: const TextStyle(fontSize: 12),
//                   ),
//                   Text(
//                     formatDuration(state.duration),
//                     style: const TextStyle(fontSize: 12),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 15),
//             GestureDetector(
//               onTap: () {
//                 context.read<SongPlayerCubit>().playOrPauseSong();
//               },
//               child: Container(
//                 height: 65,
//                 width: 65,
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: AppColors.primary,
//                 ),
//                 child: Icon(
//                   state.isPlaying
//                       ? Icons.pause_rounded
//                       : Icons.play_arrow_rounded,
//                   size: 40,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   String formatDuration(Duration duration) {
//     final minutes = duration.inMinutes.remainder(60);
//     final seconds = duration.inSeconds.remainder(60);
//     return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
//   }
// }
