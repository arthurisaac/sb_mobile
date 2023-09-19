import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartbox/app/routes.dart';
import 'package:smartbox/features/auth/cubits/auth_cubit.dart';
import 'package:smartbox/ui/profile/update_profile_screen.dart';
import 'package:smartbox/ui/utils/strings_constants.dart';
import 'package:smartbox/ui/utils/widgets_utils.dart';

import '../utils/constants.dart';
import 'change_password_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
              image: DecorationImage(
                image: ExactAssetImage('images/gift_profile_bg.png'),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            //title: const Text(profile),
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
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: Column(
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
              Center(
                  child: Text(
                    "${context.read<AuthCubit>().getNom()} ${context.read<AuthCubit>().getPrenom()}",
                    style:
                    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  )),
              const SizedBox(
                height: 5,
              ),
              Center(
                  child: Text(
                    context.read<AuthCubit>().getEmail(),
                    style: const TextStyle(color: Colors.white),
                  )),
              const SizedBox(
                height: 5,
              ),
              Center(
                  child: Text(
                    context.read<AuthCubit>().getMobile(),
                    style: const TextStyle(color: Colors.white),
                  )),
              const SizedBox(
                height: 35,
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(23),
                          topRight: Radius.circular(23))),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const UpdateProfileScreen()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(space),
                          child: Column(
                            children: [
                              Text(
                                "Informations personnelles",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text("Mettre à jour"),
                            ],
                          ),
                        ),
                      ),
                      const Divider(),
                      GestureDetector(
                        onTap: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ChangePasswordScreen()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(space),
                          child: Column(
                            children: [
                              Text(
                                "Mot de passe",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text("Changer le mot de passe"),
                            ],
                          ),
                        ),
                      ),
                      const Divider(),
                      GestureDetector(
                        onTap: () async {
                          context.read<AuthCubit>().signOut();
                          Navigator.of(context).pushReplacementNamed(Routes.login);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(space),
                          child: Column(
                            children: [
                              Text(
                                "Déconnexion",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text("Déconnecter le compte"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )

              /*Row(
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
              ),*/
            ],
          ),
        ),
      ],
    );
  }
}
