import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/authentication/login_screen.dart';
import 'package:untitled1/constants.dart';
import 'package:untitled1/providers/authentication_provider.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  String? otpCode;

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //get the arguments
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final verificationId = args[Constants.verificationId] as String;
    final phoneNumber = args[Constants.phoneNumber] as String;

    final authProvider = context.watch<AuthenticationProvider>();

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: GoogleFonts.openSans(
        fontWeight: FontWeight.w600,
        fontSize: 22
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
        border: Border.all(
          color: Colors.transparent,
        )
      ),

    );
    return Scaffold(
      body: SafeArea(
        
        child: Center(

          child: Container(
            height: MediaQuery.sizeOf(context).height/1.7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color:  Constants.sProjectColor,
                width: 2,
                style: BorderStyle.solid
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal:20, vertical:  20),
            margin: const EdgeInsets.symmetric( horizontal: 10, vertical: 20),

            child: Column(

              children: [
                SizedBox(height: 50),
                Text('Verification',
                style: GoogleFonts.openSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 50 ),
                Text('Enter the 6-digit code sent the number',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10 ),
                Text(phoneNumber,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30 ),
                SizedBox(height: 68,
                child: Pinput(
                  length: 6,
                  controller: controller,
                  focusNode: focusNode,
                  defaultPinTheme: defaultPinTheme,
                  onCompleted: (pin){
                    setState(() {
                      otpCode = pin;
                    });
                    //verify otpCode
                    verifyOTPCode(
                        verificationId: verificationId,
                        otpCode: otpCode!);
                  },
                focusedPinTheme: defaultPinTheme.copyWith(
                  height: 68,
                  width: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Constants.fProjectColor,
                    border: Border.all(
                      color: Constants.sProjectColor
                    )
                  ),
                ),
                  errorPinTheme: defaultPinTheme.copyWith(
                    height: 68,
                    width: 64,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade200,
                        border: Border.all(
                            color: Colors.red,
                        )
                    ),
                  ),
                ),
                  ),
                SizedBox(height: 30 ),

                Text('Did\'t receive the code ?',
                style: GoogleFonts.openSans(
                  fontSize: 16
                ),
                ),

                SizedBox(height: 10),
                authProvider.isLoading
                ? const CircularProgressIndicator()
                : const SizedBox.shrink(),

                authProvider.isSuccessful ? Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape:  BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.done,
                    color: Colors.white,
                    size: 30,
                  ),
                ) : SizedBox.shrink(),

                authProvider.isLoading ? SizedBox.shrink():
                TextButton(onPressed: (){
                  //TODO resend code
                },
                    child: Text('Resend Code',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Constants.sProjectColor
                    ),
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void verifyOTPCode({
    required String verificationId,
    required String otpCode,

}) async{
    final authProvider = context.read<AuthenticationProvider>();
    authProvider.verifyOTPCode(
        verificationId: verificationId,
        otpCode: otpCode,
        context: context,
        onSuccess: () async {
          //check if user exist in firestore
          bool userExists = await authProvider.checkUserExists();

          if(userExists){
            // if user exist
            //save user information from firestore
            await authProvider.getUserDataFromFireStore();

            //save user information to provider / shered preferences
            await authProvider.saveUserDataToSharedPreferences();

            //navigate to home screen
            navigate(userExists: true);
          } else {
            navigate(userExists: false);
          }
        });

  }
  void navigate({required bool userExists}){
    if (userExists){
      //navigate to home and remove all previous routes
      Navigator.pushNamedAndRemoveUntil(
        context,
        Constants.homeScreen,
            (route)=> false,

      );
    }else{
      //navigate to user information screen
      Navigator.pushNamed(
          context,
          Constants.userInformationScreen,
      );
    }
  }
}
