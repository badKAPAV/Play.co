import 'package:flutter/material.dart';
import 'package:musify/common/helpers/is_dark_mode.dart';
import 'package:musify/core/config/theme/app_colors.dart';

class SearchTabs extends StatelessWidget {
  final TabController controller;

  const SearchTabs({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: TabBar(
        controller: controller,
        splashFactory: NoSplash.splashFactory,
        dividerColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 35),
        indicatorSize: TabBarIndicatorSize.label,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: AppColors.primary,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Satoshi',
          fontWeight: FontWeight.w300,
          fontSize: 14,
          color: context.isDarkMode
              ? AppColors.lightBackground
              : AppColors.darkBackground,
        ),
        labelStyle: TextStyle(
          fontFamily: 'Satoshi',
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: context.isDarkMode ? AppColors.darkBackground : Colors.white,
        ),
        tabs: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text('Songs'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text('Artists'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text('Albums'),
          ),
        ],
      ),
    );
  }
}
