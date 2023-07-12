import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartbox/ui/main/main_screen.dart';
import 'package:smartbox/utils/my_firebase_util.dart';

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
    MyFirebaseUtil().getToken();

    super.initState();
  }

  void navigateToNextScreen() async {
    if (!mounted) return;
    final currentAuthState =  context.read<AuthCubit>().state;
    if (currentAuthState is Authenticated) {
      //Navigator.of(context).pushReplacementNamed(Routes.home, arguments: false);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MainScreen()));
    } else {
      Navigator.of(context).pushReplacementNamed(Routes.country_choice);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Image.asset("images/smartbox_logo.png", width: MediaQuery.of(context).size.width * 0.8,),
        ),
      ),
    );
  }
}
