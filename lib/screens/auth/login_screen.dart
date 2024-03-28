import 'package:flutter/material.dart';
import 'package:smf/utils/values/app_constant.dart';

import '../../utils/color/app_color.dart';
import '../../utils/extension/theme.dart';
import '../navigation/navigation_screen.dart';

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
      appBar: customAppBar(),
      body: initBuildUi(),
    );
  }

  Widget initBuildUi(){
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        initHeaderUi(),
        initUserInputUi(),
        initLoginSocialUi(),
      ],
    );
  }

  Widget initHeaderUi(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(AppConstant.welcomePlainText,style: TextStyle(color: AppColor.sepiaBlack,fontWeight: FontWeight.bold,fontSize: 30),),
        Text(AppConstant.loginToYourAccountPlainText,style: TextStyle(color: AppColor.dustyGray,fontSize: 20),),
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
          forgotPasswordUi((){})
        ],
      ),
    );
  }

  Widget initLoginSocialUi(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomButton(content: AppConstant.loginPlainText, contentColor: AppColor.white, backgroundColor: AppColor.killarney, onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
        }),
        SizedBox(height: 10,),
        orTextUI(),
        SizedBox(height: 10,),
        socialLoginUi()
      ],
    );
  }
}
