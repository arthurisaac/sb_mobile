import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smartbox/app/routes.dart';

import '../features/auth/auth_repository.dart';
import '../features/auth/cubits/auth_cubit.dart';
import '../features/auth/cubits/register_cubiti.dart';
import '../features/auth/cubits/sign_in_cubit.dart';
import '../ui/utils/constants.dart';

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
        BlocProvider<SignUpCubit>(create: (_) => SignUpCubit(AuthRepository())),
        BlocProvider<SignInCubit>(create: (_) => SignInCubit(AuthRepository())),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            builder: (context, widget) {
              return ScrollConfiguration(
                  behavior: GlobalScrollBehavior(), child: widget!);
            },
            debugShowCheckedModeBanner: true,
            initialRoute: Routes.splash,
            onGenerateRoute: Routes.onGenerateRouted,
          );
        },
      ),
    );
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
