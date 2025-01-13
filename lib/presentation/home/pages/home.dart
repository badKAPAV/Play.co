import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:musify/common/bloc/auth/auth_cubit.dart';
import 'package:musify/common/bloc/auth/auth_state.dart';
import 'package:musify/common/helpers/is_dark_mode.dart';
import 'package:musify/common/widgets/appbar/app_bar.dart';
import 'package:musify/core/config/assets/app_images.dart';
import 'package:musify/core/config/assets/app_vectors.dart';
import 'package:musify/core/config/theme/app_colors.dart';
import 'package:musify/domain/entities/auth/user.dart';
import 'package:musify/presentation/home/pages/home_nav.dart';
import 'package:musify/presentation/home/widgets/new_songs.dart';
import 'package:musify/presentation/home/widgets/playlist.dart';
import 'package:musify/presentation/profile/pages/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: BasicAppBar(
          hideBack: true,
          leading: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              //final UserEntity? user = state.user;
              return IconButton(
                onPressed: () {
                  HomeNavPage.scaffoldKey.currentState?.openDrawer();
                },
                icon: Icon(
                  Icons.menu_rounded,
                  color: context.isDarkMode ? Colors.white : Colors.black,
                ),
              );
            },
          ),
          // action: IconButton(
          //     onPressed: () {
          //       Navigator.of(context)
          //           .push(MaterialPageRoute(builder: (_) => const ProfilePage()));
          //     },
          //     icon: const Icon(Icons.person_rounded)),
          title: const Row(
            children: [
              Text(
                'Play',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                '.co',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ],
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //_homeTopCard(),
            _tabs(),
            SizedBox(
              height: 260,
              child: TabBarView(controller: _tabController, children: [
                const NewSongs(),
                Container(),
                Container(),
                Container(),
              ]),
            ),
            const SizedBox(
              height: 30,
            ),
            const Playlist(),
          ],
        ),
      ),
    );
  }

  // Widget _homeTopCard() {
  //   return Center(
  //     child: SizedBox(
  //       height: 140,
  //       child: Stack(children: [
  //         Align(
  //             alignment: Alignment.bottomCenter,
  //             child: SvgPicture.asset(
  //               AppVectors.homeTopCard,
  //               color: AppColors.primary,
  //             )),
  //         const Padding(
  //           padding: EdgeInsets.only(left: 70, top: 25),
  //           child: SizedBox(
  //             width: 150,
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   'New Album',
  //                   style:
  //                       TextStyle(fontSize: 10, fontWeight: FontWeight.normal),
  //                 ),
  //                 SizedBox(
  //                   height: 0,
  //                 ),
  //                 Text(
  //                   'Happier Than Ever',
  //                   overflow: TextOverflow.fade,
  //                   style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
  //                 ),
  //                 SizedBox(
  //                   height: 0,
  //                 ),
  //                 Text(
  //                   'Billie Eilish',
  //                   style:
  //                       TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //         Align(
  //           alignment: Alignment.bottomRight,
  //           child: Padding(
  //             padding: const EdgeInsets.only(right: 50),
  //             child: Image.asset(
  //               AppImages.topCardArtist,
  //               //height: 160,
  //             ),
  //           ),
  //         ),
  //       ]),
  //     ),
  //   );
  // }

  Widget _tabs() {
    return Center(
      child: TabBar(
        splashFactory: NoSplash.splashFactory,
        dividerColor: Colors.transparent,
        controller: _tabController,
        labelColor: context.isDarkMode ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        indicatorColor: AppColors.primary,
        indicatorWeight: 3,
        tabs: const [
          Text(
            'New',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          Text(
            'Artists',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          Text(
            'Videos',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          Text(
            'Podcasts',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
