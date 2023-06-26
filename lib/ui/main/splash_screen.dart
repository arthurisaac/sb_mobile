import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/routes.dart';
import '../../features/auth/cubits/auth_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      navigateToNextScreen();
    });
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    super.initState();
  }

  void navigateToNextScreen() async {
    final currentAuthState = context.read<AuthCubit>().state;
    if (currentAuthState is Authenticated) {
      Navigator.of(context).pushReplacementNamed(Routes.home, arguments: false);
    } else {
      Navigator.of(context).pushReplacementNamed(Routes.country_choice);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Smartbox!"),
      ),
    );
  }
}
