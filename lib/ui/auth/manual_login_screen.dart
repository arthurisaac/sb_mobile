import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartbox/ui/auth/forget_password_screen.dart';
import 'package:smartbox/ui/auth/registration_screen.dart';
import 'package:smartbox/ui/utils/ui_utils.dart';

import '../../features/auth/cubits/auth_cubit.dart';
import '../../features/auth/cubits/sign_in_cubit.dart';
import '../main/main_screen.dart';
import '../utils/constants.dart';
import '../utils/widgets_utils.dart';

class ManualLoginScreen extends StatefulWidget {
  const ManualLoginScreen({Key? key}) : super(key: key);

  @override
  State<ManualLoginScreen> createState() => _ManualLoginScreenState();
}

class _ManualLoginScreenState extends State<ManualLoginScreen> {
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
  late bool _passwordVisible;

  GlobalKey<ScaffoldState>? scaffoldKey;
  final _formKey = GlobalKey<FormState>();

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

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage("images/login_bg.png"),
            fit: BoxFit.cover,
          )),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            iconTheme: const IconThemeData(color: Colors.black),
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(space),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      spaceWidget,
                      const Icon(Icons.lock, size: 150,),
                      spaceWidget,
                      spaceWidget,
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.text,
                        showCursor: false,
                        readOnly: false,
                        decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "Email",
                          errorText: null,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(sbInputRadius),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty ||
                              !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) {
                            return 'Entrer un email valide!';
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
                      spaceWidget,
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                              const ForgetPasswordScreen()));
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(space),
                          child: Text("Mot de passe oublié ?"),
                        ),
                      ),
                      spaceWidget,
                      spaceWidget,
                      BlocConsumer<SignInCubit, SignInState>(
                          bloc: context.read<SignInCubit>(),
                          listener: (context, state) async {
                            if (state is SignInProgress) {
                              UiUtils.modalLoading(
                                  context, 'Connexion en cours...');
                            } else if (state is SignInFailure) {
                              //if (!mounted) return;
                              Navigator.of(context).pop();

                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (_) {
                                  return Dialog(
                                    backgroundColor: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // The loading indicator
                                          const Icon(
                                            Icons.error,
                                            color: Colors.red,
                                            size: 96,
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          // Some text
                                          Text(state.errorMessage),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Theme.of(context).primaryColor,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        sbInputRadius),
                                              ),
                                            ),
                                            onPressed: () {
                                              //if (!mounted) return;
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Fermer"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                              /*UiUtils.setSnackBar(
                                "Connexion ", state.errorMessage, context, false);*/
                            } else if (state is SignInSuccess) {

                              Navigator.of(context).pop();
                              context
                                  .read<AuthCubit>()
                                  .updateDetails(authModel: state.authModel);
                              /* Navigator.of(context).pushReplacementNamed(
                                Routes.home,
                                arguments: false);*/
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const MainScreen()));
                            }
                          },
                          builder: (context, state) {
                            return TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white, shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: Theme.of(context).primaryColor,
                                minimumSize: const Size.fromHeight(12),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (emailController.text.isNotEmpty &&
                                      passwordController.text.isNotEmpty) {
                                    context.read<SignInCubit>().signInUser(
                                        email: emailController.text,
                                        password: passwordController.text);
                                  } else {}
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(14),
                                child: const Center(
                                  child: Text("Connexion"),
                                ),
                              ),
                            );
                          }),
                      const SizedBox(height: 30,),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                              const RegistrationScreen()));
                        },
                        child: const Column(
                          children: [
                            Text(
                              "Pas de compte ?",
                              style: TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            Text(
                              "Créer",
                              style: TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
