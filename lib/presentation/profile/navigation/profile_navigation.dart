import 'package:flutter/material.dart';
import 'package:musify/presentation/home/pages/home.dart';

class ProfileNavigation extends StatefulWidget {
  const ProfileNavigation({super.key});

  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<ProfileNavigation> createState() => _ProfileNavigationState();
}

class _ProfileNavigationState extends State<ProfileNavigation> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: ProfileNavigation.navigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return const HomePage(); // Default to HomePage
          },
        );
      },
    );
  }
}
