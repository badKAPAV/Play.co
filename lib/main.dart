import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:musify/common/bloc/auth/auth_cubit.dart';
import 'package:musify/common/bloc/auth/auth_state.dart';
import 'package:musify/common/helpers/is_dark_mode.dart';
import 'package:musify/core/config/theme/app_theme.dart';
import 'package:musify/firebase_options.dart';
import 'package:musify/presentation/auth/pages/signin.dart';
import 'package:musify/presentation/choose_mode/bloc/theme_cubit.dart';
import 'package:musify/presentation/home/pages/home.dart';
import 'package:musify/presentation/home/pages/home_nav.dart';
import 'package:musify/presentation/song_player/bloc/song_player_cubit.dart';
import 'package:musify/service_locator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:musify/data/sources/auth/auth_firebase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDependencies();
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Transparent status bar
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider(create: (_) => SongPlayerCubit()),
        BlocProvider(
          create: (context) => AuthCubit()..checkAuthState(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) => MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: mode,
          debugShowCheckedModeBanner: false,
          home: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return Scaffold(
                  body: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Play',
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: context.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                fontFamily: 'Satoshi'),
                          ),
                          const Text(
                            '.co',
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontFamily: 'Satoshi'),
                          ),
                        ],
                      )),
                );
              } else if (state is Authenticated) {
                return HomeNavPage();
              } else {
                return SigninPage();
              }
            },
          ),
        ),
      ),
    );
  }
}
