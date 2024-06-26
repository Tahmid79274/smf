import 'package:flutter/material.dart';

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
        CustomButton(content: AppConstant.signUpPlainText, contentColor: AppColor.white, backgroundColor: AppColor.killarney, onPressed: (){}),
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
        socialLoginUi()
      ],
    );
  }

}
