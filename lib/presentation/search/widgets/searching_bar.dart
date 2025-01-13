import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musify/core/config/theme/app_colors.dart';
import 'package:musify/presentation/search/bloc/artist_search_cubit.dart';
import 'package:musify/presentation/search/bloc/song_search_cubit.dart';
import 'package:musify/common/helpers/is_dark_mode.dart';

class SearchingBar extends StatelessWidget {
  final TextEditingController controller;

  const SearchingBar({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: context.isDarkMode ? AppColors.lightGrey : Colors.white,
      ),
      child: Center(
        child: TextFormField(
          onChanged: (query) {
            context.read<SongSearchCubit>().onTextChanged(query);
            context.read<ArtistSearchCubit>().onTextChanged(query);
          },
          controller: controller,
          cursorColor: context.isDarkMode ? Colors.black : AppColors.darkGrey,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: context.isDarkMode ? Colors.black : AppColors.darkGrey),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search_rounded,
              color: context.isDarkMode ? Colors.black : AppColors.darkGrey,
              size: 30,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 11.0),
            hintText: 'What\'s playing today?',
            hintStyle: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: context.isDarkMode ? AppColors.darkGrey : Colors.black54,
            ),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
