import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartbox/ui/utils/api_body_parameters.dart';
import 'package:smartbox/ui/utils/ui_utils.dart';
import 'package:smartbox/ui/utils/widgets_utils.dart';

import '../utils/api_utils.dart';
import '../utils/constants.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController messageController = TextEditingController(text: "");

  final _formKey = GlobalKey<FormState>();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String supportPhone = "";
  String supportChat = "";
  String supportMail = "";

  Future<void> getSupportContact() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      supportPhone = prefs.getString("support_phone") ?? "";
      supportChat = prefs.getString("support_chat") ?? "";
      supportMail = prefs.getString("support_mail") ?? "";
    });
  }

  @override
  void initState() {
    getSupportContact();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contactez-nous"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            spaceWidget,
            Lottie.asset(
              'images/animation_contact_us.json',
              width: 300,
              height: 200,
              fit: BoxFit.fill,
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: buildCard(
                        title: "Appel",
                        icon: Icons.call,
                        color: Colors.orangeAccent,
                        onPressed: () {
                          var url = "tel:$supportPhone";
                          _launchURL(url);
                        }),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: buildCard(
                        title: "Mail",
                        icon: Icons.mail,
                        color: Colors.greenAccent,
                        onPressed: () {
                          var url0 = "mailto:$supportMail";
                          _launchURL(url0);
                        }),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: buildCard(
                        title: "Chat",
                        icon: Icons.chat_outlined,
                        color: Colors.purpleAccent,
                        onPressed: () {
                          String uri = supportChat;
                          _launchURL(Uri.encodeFull(uri));
                        }),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              margin: const EdgeInsets.all(space),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(36),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // Shadow position
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(space),
                  child: Column(
                    children: [
                      Text("Contact rapide",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      spaceWidget,
                      spaceWidget,
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.text,
                        showCursor: true,
                        readOnly: false,
                        decoration: InputDecoration(
                          labelText: "Adresse mail",
                          hintText: "Entrez votre adresse mail",
                          errorText: null,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(sbInputRadius),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Adresse mail requise';
                          }
                          return null;
                        },
                        onTap: () {},
                      ),
                      spaceWidget,
                      TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        showCursor: true,
                        readOnly: false,
                        decoration: InputDecoration(
                          labelText: "Nom",
                          hintText: "Entrez votre nom",
                          errorText: null,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(sbInputRadius),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Votre nom est requis';
                          }
                          return null;
                        },
                        onTap: () {},
                      ),
                      spaceWidget,
                      TextFormField(
                        controller: messageController,
                        keyboardType: TextInputType.multiline,
                        showCursor: true,
                        readOnly: false,
                        decoration: InputDecoration(
                          labelText: "Message",
                          hintText: "Entrez votre message svp",
                          errorText: null,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(sbInputRadius),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Entrer un message valide!';
                          }
                          return null;
                        },
                        onTap: () {},
                      ),
                      spaceWidget,
                      spaceWidget,
                      spaceWidget,
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                          minimumSize: const Size.fromHeight(12),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (emailController.text.isNotEmpty &&
                                nameController.text.isNotEmpty &&
                                messageController.text.isNotEmpty) {
                              sendMessage();
                            } else {}
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          child: const Center(
                            child: Text("Envoyer"),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildCard(
      {required String title,
      required IconData icon,
      required Color color,
      required Function() onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ClipOval(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  color: color.withOpacity(0.2),
                  child: Icon(
                    icon,
                    size: 36,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                title,
                style: TextStyle(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }

  sendMessage() async {
    if (!mounted) return;
    UiUtils.modalLoading(context, "Envoie en cours");

    final body = {
      nameKey: nameController.text,
      emailKey: emailController.text,
      messageKey: messageController.text
    };
    final response = await http.post(Uri.parse(sendMessageUrl),
        headers: ApiUtils.getHeaders(), body: body);

    if (!mounted) return;
    Navigator.of(context).pop();

    if (response.statusCode == 200 || response.statusCode == 201) {
      nameController.text = "";
      emailController.text = "";
      messageController.text = "";

      showDialog(
        barrierDismissible: true,
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
                  Lottie.asset('images/animation_sent.json',
                      width: 200, height: 200, fit: BoxFit.fill, repeat: false),
                  const SizedBox(
                    height: 15,
                  ),
                  // Some text
                  const Padding(
                    padding: EdgeInsets.all(space),
                    child: Text(
                      "Message envoyé avec succès! Nous vous répondrons dans les plus brefs délais",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(sbInputRadius),
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
    } else {
      return null;
    }
  }

  void _launchURL(url) async => await launchUrl(url);
}
