import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartbox/ui/auth/manual_login_screen.dart';
import 'package:smartbox/ui/auth/registration_screen.dart';
import 'package:smartbox/ui/utils/widgets_utils.dart';

import '../../app/routes.dart';
import '../../features/auth/cubits/auth_cubit.dart';
import '../../features/auth/cubits/sign_in_cubit.dart';
import '../main/main_screen.dart';
import '../utils/constants.dart';
import '../utils/ui_utils.dart';

//import 'package:video_player/video_player.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
  late bool _passwordVisible;

  //late VideoPlayerController _videoPlayerController;
  //bool startedPlaying = false;

  GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  void initState() {
    scaffoldKey = GlobalKey<ScaffoldState>();
    _passwordVisible = false;

    /* _videoPlayerController =
        VideoPlayerController.asset('videos/christmas.mp4');
    _videoPlayerController.setLooping(true);
    _videoPlayerController.initialize().then((_) => setState(() {}));
    _videoPlayerController.play();*/

    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    //_videoPlayerController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  Future<bool> started() async {
    /* await _videoPlayerController.initialize();
    await _videoPlayerController.play();
    startedPlaying = true;*/
    return true;
  }

  /*Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          color: Colors.blueAccent,
          child: Center(
            child: FutureBuilder<bool>(
              future: started(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.data ?? false) {
                  return LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return SizedBox.expand(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: VideoPlayer(_videoPlayerController),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
        /*Container(
        width: double.infinity,
        height: MediaQuery
            .of(context)
            .size
            .height,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.blue,
                Colors.red,
              ],
            )
        ),
        ),*/
          ShaderMask(
            shaderCallback: (rect) {
              return const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black],
              ).createShader(Rect.fromLTRB(0, -140, rect.width, rect.height-20));
            },
            blendMode: BlendMode.darken,
            child: Container(
              decoration: const BoxDecoration(
                // gradient: LinearGradient(
                //   colors: [gradientStart, gradientEnd],
                //   begin: FractionalOffset(0, 0),
                //   end: FractionalOffset(0, 1),
                //   stops: [0.0, 1.0],
                //   tileMode: TileMode.clamp
                // ),
                image: DecorationImage(
                  image: ExactAssetImage('images/give_black.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                flex: 1,
                child: Align(
                  alignment: const FractionalOffset(0.5, 0.0),
                  child: Container(
                    margin: const EdgeInsets.only(top: 110.0),
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius:
                          20.0, // has the effect of softening the shadow
                          spreadRadius:
                          0, // has the effect of extending the shadow
                          // offset: Offset(
                          //   10.0, // horizontal, move right 10
                          //   10.0, // vertical, move down 10
                          // ),
                        )
                      ],
                    ),
                    child: Image.asset('images/smartbox_logo.png',
                        width: 150),
                  ),
                ),
              ),
              Expanded(
                flex: 0,
                child: Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Explorer de nouvelles idées de cadeau à offrir',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    )),
              ),
              Expanded(
                flex: 0,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 28.0),
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  constraints: const BoxConstraints(
                    maxWidth: 330.0,
                  ),
                  child: const Text(
                    'Nous faisons de notre mieux pour vous fournir une idée de cadeau pour vos proches.',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                flex: 0,
                child: ButtonTheme(
                  minWidth: 320.0,
                  height: 50.0,
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RegistrationScreen()));
                    },
                    textColor: Colors.blueAccent,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: const Text(
                      'S\'inscrire',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
             /* Expanded(
                flex: 0,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: ButtonTheme(
                    minWidth: 320.0,
                    height: 50.0,
                    child: MaterialButton(
                      onPressed: () {},
                      textColor: Colors.white,
                      color: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: const Text(
                        'Continuer avec Google',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),*/
              Expanded(
                flex: 0,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20.0),
                  child: ButtonTheme(
                    minWidth: 200.0,
                    height: 50.0,
                    child: MaterialButton(
                      onPressed: () {
                        //Navigator.pushNamed(context, '/signup');
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ManualLoginScreen()));
                      },
                      textColor: Colors.white,
                      child: const Text(
                        'Connexion',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
