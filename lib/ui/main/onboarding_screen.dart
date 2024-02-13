import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartbox/ui/utils/constants.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../app/routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            setState(() => isLastPage = index == 2);
          },
          children: [
            buildPage(
                color: Colors.teal.shade100,
                urlImage: 'images/1.png',
                title: "Acheter des cadeaux",
                subtitle:
                    "Acheter des cadeaux pour vos proches, vos familles et aux personnes qui vous sont proches.",
                titleColor: Colors.teal),
            buildPage(
                color: Colors.purple.shade100,
                urlImage: 'images/2.png',
                title: "Recevez et reservez",
                subtitle:
                    "Vos proches recoivent et reservent leur cadeau selon leur convenance.",
                titleColor: Colors.purple),
            buildPage(
                color: Colors.orangeAccent.shade100,
                urlImage: 'images/3.png',
                title: "Recevez et reservez",
                subtitle:
                    "Vos proches recoivent et reservent leur cadeau selon leur convenance.",
                titleColor: Colors.orange),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                backgroundColor: Theme.of(context).primaryColor,
                minimumSize: const Size.fromHeight(80),
              ),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool(showOnBoarding, true);

                if (!mounted) return;
                Navigator.of(context)
                    .pushReplacementNamed(Routes.countryChoice);
              },
              child: const Text(
                "Commencer",
                style: TextStyle(fontSize: 24),
              ),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => controller.jumpToPage(2),
                    child: const Text('Passer'),
                  ),
                  Center(
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: 3,
                      effect: WormEffect(
                          spacing: 16,
                          dotColor: Colors.black26,
                          activeDotColor: Theme.of(context)
                              .primaryColor //Colors.teal.shade700,
                          ),
                      onDotClicked: (index) => controller.animateToPage(index,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn),
                    ),
                  ),
                  TextButton(
                    onPressed: () => controller.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    ),
                    child: const Text('Suivant'),
                  )
                ],
              ),
            ),
    );
  }

  Widget buildPage(
          {required Color color,
          required String urlImage,
          required String title,
          required Color titleColor,
          required String subtitle}) =>
      Container(
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(60),
              height: MediaQuery.of(context).size.height * 0.5,
              child: Image.asset(
                urlImage,
                //fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            const SizedBox(
              height: 44,
            ),
            Text(
              title,
              style: TextStyle(
                color: titleColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      );
}
