import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Fixed import for SvgPicture
import 'package:musify/common/helpers/is_dark_mode.dart';
import 'package:musify/core/config/assets/app_vectors.dart';
import 'package:musify/core/config/theme/app_colors.dart';

class BasicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? leading;
  final bool hideBack;
  final Widget? action;
  final double appbarHeight;
  final Widget? flexibleSpace;

  const BasicAppBar({
    Key? key,
    this.flexibleSpace,
    this.title,
    this.leading,
    this.hideBack = false,
    this.appbarHeight = 56.0,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: flexibleSpace ?? Container(),
      titleSpacing: 20.0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      leading: leading ??
          (hideBack
              ? null
              : Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.isDarkMode
                            ? Colors.white.withOpacity(0.04)
                            : Colors.black.withOpacity(0.04),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppVectors.back,
                          height: 15.0,
                          width: 15.0,
                          color: context.isDarkMode
                              ? AppColors.grey
                              : AppColors.darkGrey,
                        ),
                      ),
                    ),
                  ),
                )),
      title: title ?? const SizedBox.shrink(),
      actions: action != null ? [action!] : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appbarHeight);
}
