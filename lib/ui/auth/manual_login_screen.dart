import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartbox/ui/auth/registration_screen.dart';

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
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(space),
              child: Column(
                children: [
                  spaceWidget,
                  Text(
                    "Connexion",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
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
                              });
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
                                        Text('${state.errorMessage}'),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary:
                                                Theme.of(context).primaryColor,
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
                                          child: Text("Fermer"),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                          /*UiUtils.setSnackBar(
                            "Connexion ", state.errorMessage, context, false);*/
                        } else if (state is SignInSuccess) {
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
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
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
                            child: const Center(
                              child: Text("Connexion"),
                            ),
                          ),
                        );
                      }),
                  spaceWidget,
                  /*TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const RegistrationScreen()),
                        );
                      },
                      child: const Text("S'inscrire"))*/
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
