import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musify/common/helpers/is_dark_mode.dart';
import 'package:musify/common/widgets/appbar/app_bar.dart';
import 'package:musify/common/widgets/favorite_button/favorite_button.dart';
import 'package:musify/core/config/constants/app_urls.dart';
import 'package:musify/core/config/theme/app_colors.dart';
import 'package:musify/domain/entities/song/song.dart';
import 'package:musify/presentation/song_player/bloc/song_player_cubit.dart';
import 'package:musify/presentation/song_player/bloc/song_player_state.dart';
import 'package:palette_generator/palette_generator.dart';

class SongPlayerPage extends StatefulWidget {
  final SongEntity songEntity;
  const SongPlayerPage({super.key, required this.songEntity});

  @override
  State<SongPlayerPage> createState() => _SongPlayerPageState();
}

class _SongPlayerPageState extends State<SongPlayerPage> {
  Color? dominantColor;

  @override
  void initState() {
    super.initState();
    extractDominantColor();
  }

  @override
  void didUpdateWidget(SongPlayerPage oldWidget) {
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
      return hsl.lightness > 0.2
          ? hsl.withLightness(0.2).toColor()
          : hsl.toColor();
    } else {
      // In light mode, ensure color isn't too dark
      return hsl.lightness < 0.6
          ? hsl.withLightness(0.6).toColor()
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
        return Scaffold(
          backgroundColor: color,
          appBar: BasicAppBar(
            title: const Text('Now Playing',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            action:
                IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
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
      },
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
          FavoriteButton(songEntity: widget.songEntity)
        ],
      ),
    );
  }

  Widget _songPlayer(BuildContext context) {
    return BlocBuilder<SongPlayerCubit, SongPlayerState>(
      builder: (context, state) {
        print('Current state in _songPlayer is $state');
        if (state is SongPlayerLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is SongPlayerLoaded) {
          print("Song duration: ${state.duration}");
          print("Song position: ${state.position}");
          print("Is playing: ${state.isPlaying}");

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Container(
              color: Colors.green.withOpacity(0.2),
              child: Column(
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 6),
                      thumbColor: Colors.white,
                      trackHeight: 6,
                      activeTrackColor: AppColors.lightPrimary,
                    ),
                    child: Slider(
                      value: state.position.inSeconds.toDouble(),
                      onChanged: (value) {
                        context
                            .read<SongPlayerCubit>()
                            .seekTo(Duration(seconds: value.toInt()));
                      },
                      min: 0.0,
                      max: state.duration.inSeconds.toDouble(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatDuration(state.position),
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          formatDuration(state.duration),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      context.read<SongPlayerCubit>().playOrPauseSong();
                    },
                    child: Container(
                      height: 65,
                      width: 65,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                      child: Icon(
                        state.isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        size: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (state is SongPlayerFailure) {
          return const Center(
            child: Text('Error loading song'),
          );
        }
        return Container();
      },
    );
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
