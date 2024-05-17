import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smf/utils/functionalities/firebase_database_functionality.dart';
import 'package:smf/utils/functionalities/shared_prefs_manager.dart';
import 'package:smf/utils/values/app_constant.dart';

import '../../utils/color/app_color.dart';
import '../../utils/extension/theme.dart';
import '../../utils/functionalities/functions.dart';
import '../navigation/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: CustomAppBar(title: ''),
      body: initBuildUi(),
    );
  }

  Widget initBuildUi() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 50,
          ),
          initHeaderUi(),
          SizedBox(
            height: 50,
          ),
          initUserInputUi(),
          SizedBox(
            height: 50,
          ),
          initLoginSocialUi(),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  Widget initHeaderUi() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          AppConstant.welcomePlainText,
          style: TextStyle(
              color: AppColor.sepiaBlack,
              fontWeight: FontWeight.bold,
              fontSize: 30),
        ),
        Text(
          AppConstant.loginToYourAccountPlainText,
          style: TextStyle(color: AppColor.dustyGray, fontSize: 20),
        ),
      ],
    );
  }

  Widget initUserInputUi() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerWithTextFormField(AppConstant.emailPlainText,
              AppConstant.examplePlainText, emailController),
          SizedBox(
            height: 10,
          ),
          Text(AppConstant.passwordPlainText,
              style: TextStyle(
                  color: AppColor.sepiaBlack,
                  fontWeight: FontWeight.bold,
                  fontSize: 30)),
          TextFormField(
            keyboardType: TextInputType.text,
            obscureText: showPassword,
            controller: passwordController,
            decoration: InputDecoration(
                hintText: AppConstant.examplePasswordPlainText,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                isDense: false,
                suffixIcon: IconButton(
                  icon: Icon(
                      showPassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                  padding: EdgeInsets.zero,
                ),
                border: borderColorAltoRadius5()),
          ),
          //forgotPasswordUi(() {})
        ],
      ),
    );
  }

  Widget initLoginSocialUi() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomButton(
            content: AppConstant.loginPlainText,
            contentColor: AppColor.white,
            backgroundColor: AppColor.killarney,
            onPressed: () async {
              showLoader(context);
              try {
                print(
                    'Before check-${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}');
                final credential = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text)/*
                    .timeout(Duration(seconds: 5))*/;
                print('After Login Check ends:${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}');

              } catch (e) {
                if (e is FirebaseAuthException) {
                  if (e.code == 'user-not-found') {
                    print('No user found for that email.');
                    showErrorSnackBar('No user found for that email.', context);
                  } else if (e.code == 'wrong-password') {
                    print('Wrong password provided for that user.');
                    showErrorSnackBar(
                        'Wrong password provided for that user.', context);
                  } else {
                    showErrorSnackBar('${e.code}', context);
                    print("An error occurred: ${e.code}");
                    // Handle other FirebaseAuthExceptions
                  }
                } else {
                  print("An unexpected error occurred: ${e}");
                }
              }
              removeLoader(context);
              FirebaseAuth.instance
                  .authStateChanges()
                  .listen((User? user) {
                if (user != null) {
                  GlobalVar.basePath = user.email!.replaceAll('.', '_');
                  print('User Email after login:${GlobalVar.basePath}');
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreen()), (route) => false);
                }
                else{
                  print('No email in login page');
                }
              });
            }),
        SizedBox(
          height: 10,
        ),
        // orTextUI(),
        SizedBox(
          height: 10,
        ),
        // SocialLoginUi(
        //   onTapAction: () async {
        //     // UserCredential user = await CustomFirebaseFunctionality.signInWithGoogle();
        //     await CustomFirebaseFunctionality.signInWithGoogle();
        //     // print('Google User email is:${user.user!.email}');
        //     FirebaseAuth.instance
        //         .authStateChanges()
        //         .listen((User? user) {
        //       if (user != null) {
        //         GlobalVar.basePath = user.email!.replaceAll('.', '_');
        //         print('User Email after login:${GlobalVar.basePath}');
        //         // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreen()), (route) => false);
        //       }
        //       else{
        //         print('No email in login page');
        //       }
        //     });
        //   },
        // )
      ],
    );
  }
}
