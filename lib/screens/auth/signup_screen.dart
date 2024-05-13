import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smf/utils/functionalities/shared_prefs_manager.dart';
import '../../utils/color/app_color.dart';
import '../../utils/extension/theme.dart';
import '../../utils/values/app_constant.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  TextEditingController nameController = TextEditingController();
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

  Widget initBuildUi(){
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomHeader(title: AppConstant.startPlainText,subtitle: AppConstant.toMoveFurtherCreateAccountPlainText),
        initUserInputUi(),
        initSignupSocialUi(),
      ],
    );
  }

  Widget initUserInputUi(){
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerWithTextFormField(AppConstant.namePlainText,AppConstant.exampleNamePlainText,nameController),
          SizedBox(height: 10,),
          headerWithTextFormField(AppConstant.emailPlainText,AppConstant.examplePlainText,emailController),
          SizedBox(height: 10,),
          Text(AppConstant.passwordPlainText,style: TextStyle(color: AppColor.sepiaBlack,fontWeight: FontWeight.bold,fontSize: 30)),
          TextFormField(
            keyboardType: TextInputType.text,
            obscureText: showPassword,
            controller: passwordController,
            decoration: InputDecoration(
                hintText: AppConstant.examplePasswordPlainText,
                contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                isDense: false,
                suffixIcon: IconButton(icon:Icon(showPassword?Icons.visibility:Icons.visibility_off),onPressed: (){
                  setState(() {
                    showPassword = !showPassword;
                  });
                },padding: EdgeInsets.zero,),
                border: borderColorAltoRadius5()),
          ),
        ],
      ),
    );
  }

  Widget initSignupSocialUi(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomButton(content: AppConstant.signUpPlainText, contentColor: AppColor.white, backgroundColor: AppColor.killarney, onPressed: ()async{
          showLoader(context);
          try {
            final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text,
            );
            print(credential.additionalUserInfo!.authorizationCode);
            removeLoader(context);
            SharedPrefsManager.setProfileName(nameController.text);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
            // FirebaseAuth.instance
            //     .authStateChanges()
            //     .listen((User? user) {
            //   if (user != null) {
            //     print(user.uid);
            //   }
            // });
          } on FirebaseAuthException catch (e) {
            if (e.code == 'weak-password') {
              print('The password provided is too weak.');
              showErrorSnackBar('The password provided is too weak.',context);
            } else if (e.code == 'email-already-in-use') {
              print('The account already exists for that email.');
              showErrorSnackBar('The account already exists for that email.',context);
            }
          } catch (e) {
            print(e);
            showErrorSnackBar(e.toString(),context);
          }
        }),
        SizedBox(height: 10,),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(AppConstant.alreadyHaveAnAccountPlainText,style: TextStyle(color: AppColor.woodyBrown),),
            SizedBox(width: 10,),
            InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                },
                child: Text(AppConstant.loginPlainText,style: TextStyle(color: AppColor.killarney,fontWeight: FontWeight.bold),))
          ],
        ),
        orTextUI(),
        SizedBox(height: 10,),
        SocialLoginUi(onTapAction: (){},)
      ],
    );
  }

}
