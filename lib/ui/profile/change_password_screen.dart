import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartbox/features/auth/cubits/update_password_cubit.dart';
import 'package:smartbox/ui/utils/constants.dart';
import 'package:smartbox/ui/utils/strings_constants.dart';
import 'package:smartbox/ui/utils/ui_utils.dart';
import 'package:smartbox/ui/utils/widgets_utils.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController passwordController = TextEditingController(text: "");
  TextEditingController passwordConfirmationController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(changePassword),
        centerTitle: true,
        backgroundColor: const Color(0xFFd96e70),
      ),
      body: Padding(
        padding: const EdgeInsets.all(space),
        child: Column(
          children: [
            TextFormField(
              controller: passwordController,
              keyboardType: TextInputType.text,
              showCursor: false,
              readOnly: false,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: password,
                hintText: password,
                errorText: null,
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return requiredField;
                }
                return null;
              },
              onTap: () {},
            ),
            spaceWidget,
            TextFormField(
              controller: passwordConfirmationController,
              keyboardType: TextInputType.text,
              showCursor: false,
              readOnly: false,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: passwordConfirmation,
                hintText: passwordConfirmation,
                errorText: null,
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return requiredField;
                }
                return null;
              },
              onTap: () {},
            ),
            spaceWidget,
            BlocConsumer<UpdatePasswordCubit, UpdatePasswordSate>(
                bloc: context.read<UpdatePasswordCubit>(),
                builder: (context, state) {
                  return TextButton(
                    style: TextButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                      backgroundColor: const Color(0xFFd96e70).withOpacity(0.3),
                    ),
                    onPressed: () async {
                      if (passwordConfirmationController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty) {
                        context.read<UpdatePasswordCubit>().updatePassword(
                            passwordConfirmation: passwordConfirmationController.text,
                            password: passwordController.text);
                      } else {}
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(12),
                      child: const Text(goNext),
                    ),
                  );
                },
                listener: (context, state) async {
                  if (state is UpdatePasswordFailure) {
                    UiUtils.setSnackBar(login, state.errorMessage, context, false);
                  }

                  if (state is UpdatePasswordSuccess) {
                    AlertDialog alert = AlertDialog(
                      title: const Center(
                        child: Text(password),
                      ),
                      content: Text(state.message,
                        textAlign: TextAlign.center,
                      ),
                      actions: [
                        TextButton(
                          child: const Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                            passwordController.text = "";
                            passwordConfirmationController.text = "";
                          },
                        )
                      ],
                    );
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      },
                    );

                  }
                }),
          ],
        ),
      ),
    );
  }
}
