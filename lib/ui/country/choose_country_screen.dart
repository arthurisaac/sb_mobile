import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:smartbox/features/auth/auth_local_data_source.dart';
import 'package:smartbox/ui/main/main_screen.dart';
import 'package:smartbox/ui/utils/constants.dart';
import 'package:smartbox/ui/utils/widgets_utils.dart';

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              const Spacer(),
              Image.asset("images/directions_bro.png", width: MediaQuery.of(context).size.width * 0.8,),
              const Spacer(),
              const Text("Choisir le pays"),
              spaceWidget,
              TextFormField(
                controller: countryController,
                keyboardType: TextInputType.text,
                showCursor: false,
                readOnly: false,
                focusNode: FirstDisabledFocusNode(),
                decoration: InputDecoration(
                  hintText: "Pays",
                  errorText: null,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: const Color(0xFF8C98A8).withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.circular(sbInputRadius),
                  ),
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
                    favorite: <String>['BF', 'ML'],
                    //Optional. Shows phone code before the country name.
                    showPhoneCode: false,
                    onSelect: (Country country) {
                      //print('pays selectionné: ${country.name}');
                      AuthLocalDataSource auth = AuthLocalDataSource();
                      auth.setCountry(country.name);
                      auth.setCountryCode(country.countryCode);
                      setState(() {
                        countryController.text = country.name;
                      });
                    },
                    countryListTheme: CountryListThemeData(
                      // Optional. Sets the border radius for the bottomsheet.
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(sbInputRadius),
                        topRight: Radius.circular(sbInputRadius),
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
                          borderRadius: BorderRadius.circular(sbInputRadius),
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
              spaceWidget,
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(sbInputRadius),
                  ),
                ),
                onPressed: () {
                  //Navigator.of(context).pushReplacementNamed(Routes.login);
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MainScreen()));
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: const Center(child: Text("Continuer")),
                ),
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FirstDisabledFocusNode extends FocusNode {
  @override
  bool consumeKeyboardToken() {
    return false;
  }
}