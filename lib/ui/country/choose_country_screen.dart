import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:smartbox/app/routes.dart';

class ChooseCountryScreen extends StatefulWidget {
  const ChooseCountryScreen({Key? key}) : super(key: key);

  @override
  State<ChooseCountryScreen> createState() => _ChooseCountryScreenState();
}

class _ChooseCountryScreenState extends State<ChooseCountryScreen> {
  TextEditingController countryController = TextEditingController(text: "");
  String pays = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            const Text("Choisir le pays"),
            Spacer(),
            TextFormField(
              controller: countryController,
              keyboardType: TextInputType.text,
              showCursor: false,
              readOnly: false,
              decoration: InputDecoration(
                hintText: "Pays",
                errorText: null,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Vous devez choisir le pays';
                }
                return null;
              },
              onTap: () {
                showCountryPicker(
                  context: context,
                  exclude: <String>['KN', 'MF'],
                  favorite: <String>['SE'],
                  //Optional. Shows phone code before the country name.
                  showPhoneCode: false,
                  onSelect: (Country country) {
                    print('pays selectionné: ${country.name}');
                    setState(() {
                      countryController.text = country.name;
                    });
                  },
                  countryListTheme: CountryListThemeData(
                    // Optional. Sets the border radius for the bottomsheet.
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    ),
                    // Optional. Styles the search field.
                    inputDecoration: InputDecoration(
                      labelText: 'Chercher',
                      hintText: 'Saisissez le pays',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color(0xFF8C98A8).withOpacity(0.2),
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    // Optional. Styles the text in the search field
                    searchTextStyle: const TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 10,),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(Routes.login);
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Text("Continuer"),
              ),
            ),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
