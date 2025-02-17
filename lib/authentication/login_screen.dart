import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/constants.dart';

import '../providers/authentication_provider.dart';
import '../utilities/assets_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();


  Country selectedCountry = Country(
    phoneCode: '26',
    countryCode: 'ZM',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Zambia',
    example: 'Zambia',
    displayName: 'Zambia',
    displayNameNoCountryCode: 'ZM',
    e164Key: '',
  );

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: 500,
              child: Lottie.asset(AssetsManager.chatBubble),
            ),
            Text(
              'G Chat',
              style: GoogleFonts.aboreto(
                  fontSize: 28, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Add your phone number will send a code to verify',
              textAlign: TextAlign.center,
              style: GoogleFonts.aboreto(fontSize: 11),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(

              controller: _phoneNumberController,
              maxLength: 10,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              onChanged: (value) {
                setState(() {
                  _phoneNumberController.text = value;
                });
              },
              decoration: InputDecoration(

                counterText: '',
                hintText: 'Phone Number',
                hintStyle: GoogleFonts.openSans(
                    fontSize: 16, fontWeight: FontWeight.w500),
                prefixIcon: Container(
                  padding: const EdgeInsets.fromLTRB(8, 13, 8, 12),
                  child: InkWell(
                    onTap: () {
                      showCountryPicker(
                          context: context,
                          showPhoneCode: true,
                          onSelect: (Country country) {
                            setState(() {
                              selectedCountry = country;
                            });
                          });
                    },
                    child: Text(
                      '${selectedCountry.flagEmoji}+${selectedCountry.phoneCode}',
                      style: GoogleFonts.openSans(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                suffixIcon: _phoneNumberController.text.length > 8
                    ? authProvider.isLoading
                        ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        )
                        : InkWell(
                            onTap: () {
                              //signIn with phoneNumber
                              authProvider.signInWithPhoneNumber(
                                  phoneNumber:
                                      '+${selectedCountry.phoneCode} ${_phoneNumberController.text}',
                                  context: context);
                            },
                            child: Container(
                              height: 35,
                              width: 35,
                              margin: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  color: Colors.green, shape: BoxShape.circle),
                              child: const Icon(
                                Icons.done,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          )
                    : null,
                border:
                    OutlineInputBorder(
                        borderSide: const BorderSide(color: Constants.sProjectColor),
                        borderRadius: BorderRadius.circular(30)
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
