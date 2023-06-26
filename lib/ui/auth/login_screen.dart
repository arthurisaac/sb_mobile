import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartbox/ui/auth/registration_screen.dart';

import '../../app/routes.dart';
import '../../features/auth/cubits/auth_cubit.dart';
import '../../features/auth/cubits/sign_in_cubit.dart';
import '../utils/ui_utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
  late bool _passwordVisible;

  GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  void initState() {
    scaffoldKey = GlobalKey<ScaffoldState>();
    _passwordVisible = false;

    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Connexion"),
      ),
      body: Container(
        child: Column(
          children: [
            Text("Connexion"),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.text,
              showCursor: false,
              readOnly: false,
              decoration: const InputDecoration(
                labelText: "Email",
                hintText: "Email",
                errorText: null,
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Champ requis';
                }
                return null;
              },
              onTap: () {},
            ),
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
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark,
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
            BlocConsumer<SignInCubit, SignInState>(
                bloc: context.read<SignInCubit>(),
                listener: (context, state) async {
                  if (state is SignInFailure) {
                    UiUtils.setSnackBar(
                        "Connexion ", state.errorMessage, context, false);
                  } else if (state is SignInSuccess) {
                    context
                        .read<AuthCubit>()
                        .updateDetails(authModel: state.authModel);
                    Navigator.of(context)
                        .pushReplacementNamed(Routes.home, arguments: false);
                  }
                },
                builder: (context, state) {
                  return TextButton(
                    style: TextButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
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
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(12),
                      child: Text("Login"),
                    ),
                  );
                }),
            TextButton(onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegistrationScreen()));
            }, child: Text("S'inscrire"))
          ],
        ),
      ),
    );
  }
}
