import 'package:flutter/material.dart';
import 'package:musify/presentation/library/pages/library.dart';
import 'package:musify/presentation/library/widgets/playlist_page.dart';

class LibraryNavigation extends StatefulWidget {
  const LibraryNavigation({super.key});

  @override
  State<LibraryNavigation> createState() => _LibraryNavigationState();
}

class _LibraryNavigationState extends State<LibraryNavigation> {
  GlobalKey<NavigatorState> libraryNavigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: libraryNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              if (settings.name == '/playlistPage') {
                return PlaylistPage();
              }
              return LibraryPage();
            });
      },
    );
  }
}
