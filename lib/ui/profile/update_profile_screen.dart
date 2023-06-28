import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartbox/features/auth/cubits/auth_cubit.dart';
import 'package:smartbox/features/auth/cubits/update_profile_cubit.dart';
import 'package:smartbox/ui/utils/constants.dart';
import 'package:smartbox/ui/utils/strings_constants.dart';
import 'package:smartbox/ui/utils/ui_utils.dart';
import 'package:smartbox/ui/utils/widgets_utils.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  TextEditingController firstNameController = TextEditingController(text: "");
  TextEditingController lastNameController = TextEditingController(text: "");
  TextEditingController phoneController = TextEditingController(text: "");
  TextEditingController emailController = TextEditingController(text: "");

  @override
  void initState() {
    lastNameController.text = context.read<AuthCubit>().getPrenom();
    firstNameController.text = context.read<AuthCubit>().getNom();
    phoneController.text = context.read<AuthCubit>().getMobile();
    emailController.text = context.read<AuthCubit>().getEmail();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(profile),
      ),
      body: Padding(
        padding: const EdgeInsets.all(space),
        child: Column(
          children: [
            TextFormField(
              controller: lastNameController,
              keyboardType: TextInputType.text,
              showCursor: false,
              readOnly: false,
              decoration: const InputDecoration(
                labelText: lastName,
                hintText: lastName,
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
              controller: firstNameController,
              keyboardType: TextInputType.text,
              showCursor: false,
              readOnly: false,
              decoration: const InputDecoration(
                labelText: firstName,
                hintText: firstName,
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
              controller: phoneController,
              keyboardType: TextInputType.phone,
              showCursor: false,
              readOnly: false,
              decoration: const InputDecoration(
                labelText: phoneNumber,
                hintText: phoneNumber,
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
            BlocConsumer<UpdateProfileCubit, UpdateProfileSate>(
                bloc: context.read<UpdateProfileCubit>(),
                builder: (context, state) {
                  return TextButton(
                    style: TextButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                      backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.5),
                    ),
                    onPressed: () async {
                      if (firstNameController.text.isNotEmpty && lastNameController.text.isNotEmpty &&
                          phoneController.text.isNotEmpty) {
                        context.read<UpdateProfileCubit>().updateProfile(
                          nom: lastNameController.text,
                          prenom: firstNameController.text,
                          telephone: phoneController.text
                        );
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
                  if (state is UpdateProfileFailure) {
                    UiUtils.setSnackBar(login, state.errorMessage, context, false);
                  }

                  if (state is UpdateProfileSuccess) {
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
