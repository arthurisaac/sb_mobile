import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return Stack(
      children: [
      Container(
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
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(space),
            child: Column(
              children: [
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.text,
                  showCursor: false,
                  readOnly: false,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Email",
                    errorText: null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(sbInputRadius),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Champ requis';
                    }
                    return null;
                  },
                  onTap: () {},
                ),
                spaceWidget,
                TextFormField(
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  showCursor: false,
                  readOnly: false,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    labelText: "Mot de passe",
                    hintText: "Mot de passe",
                    errorText: null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(sbInputRadius),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme
                            .of(context)
                            .primaryColorDark,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Champ requis';
                    }
                    return null;
                  },
                  onTap: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
                spaceWidget,
                BlocConsumer<SignInCubit, SignInState>(
                    bloc: context.read<SignInCubit>(),
                    listener: (context, state) async {
                      if (state is SignInProgress) {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (_) {
                            return const Dialog(
                              backgroundColor: Colors.white,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // The loading indicator
                                      CircularProgressIndicator(),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      // Some text
                                      Text('Connexion en cours...')
                                    ],
                                  ),
                                ),
                            );
                          }
                        );
                      } else
                      if (state is SignInFailure) {
                        //if (!mounted) return;
                        Navigator.of(context).pop();

                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (_) {
                              return Dialog(
                                backgroundColor: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // The loading indicator
                                      const Icon(Icons.error, color: Colors.red, size: 96,),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      // Some text
                                      Text('${state.errorMessage}'),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Theme.of(context).primaryColor,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(sbInputRadius),
                                          ),
                                        ),
                                        onPressed: () {
                                          //if (!mounted) return;
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Fermer"),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                        );
                        /*UiUtils.setSnackBar(
                            "Connexion ", state.errorMessage, context, false);*/
                      } else if (state is SignInSuccess) {
                        context
                            .read<AuthCubit>()
                            .updateDetails(authModel: state.authModel);
                       /* Navigator.of(context).pushReplacementNamed(
                            Routes.home,
                            arguments: false);*/
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainScreen()));
                      }
                    },
                    builder: (context, state) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Theme
                              .of(context)
                              .primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(sbInputRadius),
                          ),
                        ),
                        onPressed: () async {
                          if (emailController.text.isNotEmpty &&
                              passwordController.text.isNotEmpty) {
                            context.read<SignInCubit>().signInUser(
                                email: emailController.text,
                                password: passwordController.text);
                          } else {}
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          child: const Center(child: Text("Connexion")),
                        ),
                      );
                    }),
                spaceWidget,
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const RegistrationScreen()));
                    },
                    child: const Text("S'inscrire"))
              ],
            ),
          ),
        ),
      ),
      ],
    );
  }
}
