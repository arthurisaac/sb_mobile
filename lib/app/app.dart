import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smartbox/app/routes.dart';
import 'package:smartbox/features/auth/cubits/update_password_cubit.dart';
import 'package:smartbox/features/auth/cubits/update_profile_cubit.dart';
import 'package:smartbox/ui/main/splash_screen.dart';

import '../features/auth/auth_repository.dart';
import '../features/auth/cubits/auth_cubit.dart';
import '../features/auth/cubits/register_cubiti.dart';
import '../features/auth/cubits/sign_in_cubit.dart';
import '../ui/utils/constants.dart';

import '../utils/firebase_options.dart';

Future<Widget> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark));

    if (defaultTargetPlatform == TargetPlatform.android) {}
  }

  await Hive.initFlutter();
  await Hive.openBox(authBox);
  return const MyApp();
}

class GlobalScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(create: (_) => AuthCubit(AuthRepository())),
          BlocProvider<SignUpCubit>(
              create: (_) => SignUpCubit(AuthRepository())),
          BlocProvider<SignInCubit>(
              create: (_) => SignInCubit(AuthRepository())),
          BlocProvider<UpdateProfileCubit>(
              create: (_) => UpdateProfileCubit(AuthRepository())),
          BlocProvider<UpdatePasswordCubit>(
              create: (_) => UpdatePasswordCubit(AuthRepository())),
        ],
        child: MaterialApp(
          builder: (context, widget) {
            return ScrollConfiguration(
                behavior: GlobalScrollBehavior(), child: widget!);
          },
          debugShowCheckedModeBanner: false,
          //initialRoute: Routes.splash,
          home: FutureBuilder(
            future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform,
            ),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Builder(
                  builder: (context) {
                    return const SplashScreen();
                  },
                );
              }

              if (snapshot.hasError) {
                if (kDebugMode) {
                  print(snapshot.error);
                }
                return Scaffold(
                  body: Center(
                    child: Icon(
                      Icons.error_outline,
                      size: MediaQuery.of(context).size.width * 0.5,
                    ),
                  ),
                );
              }

              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
          onGenerateRoute: Routes.onGenerateRouted,
          theme: ThemeData(
            cardTheme: const CardTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(sbInputRadius / 2),
                ),
              ),
            ),
          ),
        ));
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
