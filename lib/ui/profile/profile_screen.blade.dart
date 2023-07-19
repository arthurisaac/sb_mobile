import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartbox/app/routes.dart';
import 'package:smartbox/features/auth/cubits/auth_cubit.dart';
import 'package:smartbox/ui/profile/update_profile_screen.dart';
import 'package:smartbox/ui/utils/strings_constants.dart';
import 'package:smartbox/ui/utils/widgets_utils.dart';

import 'change_password_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(profile),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.login_outlined),
            tooltip: logout,
            onPressed: () {
              context.read<AuthCubit>().signOut();
              Navigator.of(context).pushReplacementNamed(Routes.login);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              spaceWidget,
              Center(
                child: Image.network(
                  "https://ui-avatars.com/api/?name=${context.read<AuthCubit>().getNom()}${context.read<AuthCubit>().getPrenom()}&rounded=true",
                  fit: BoxFit.fill,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              ),
              spaceWidget,
              Row(
                children: [
                  Text(
                    lastName,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 42,
                  ),
                  Text(" ${context.read<AuthCubit>().getNom()}"),
                ],
              ),
              spaceWidget,
              Row(
                children: [
                  Text(
                    firstName,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 42,
                  ),
                  Text(" ${context.read<AuthCubit>().getPrenom()}"),
                ],
              ),
              spaceWidget,
              Row(
                children: [
                  Text(
                    phoneNumber,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Text(context.read<AuthCubit>().getMobile()),
                ],
              ),
              spaceWidget,
              Row(
                children: [
                  Text(
                    email,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Text(context.read<AuthCubit>().getEmail()),
                ],
              ),
              spaceWidget,
              spaceWidget,
              TextButton.icon(
                style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.3),
                ),
                onPressed: () async {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const UpdateProfileScreen()));
                },
                label: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(12),
                  child: const Text(changeProfile,style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),),
                ),
                icon: const Icon(Icons.person, color: Colors.black,),
              ),
              spaceWidget,
              TextButton.icon(
                style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                  //backgroundColor: const Color(0xFFd96e70).withOpacity(0.3),
                ),
                onPressed: () async {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ChangePasswordScreen()));
                },
                label: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(12),
                  child: const Text(changePassword,style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),),
                ),
                icon: const Icon(Icons.password, color: Colors.black,)
              ),
            ],
          ),
        ),
      ),
    );
  }
}
