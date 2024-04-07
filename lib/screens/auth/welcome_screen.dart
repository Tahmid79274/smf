import 'package:flutter/material.dart';
import 'package:smf/screens/auth/login_screen.dart';
import 'package:smf/screens/auth/signup_screen.dart';
import '../../utils/extension/theme.dart';
import '../../utils/values/app_constant.dart';
import '../../utils/color/app_color.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColor.timberGreen,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            logoWithTextUi(),
            welcomeLogoWithTextUi(),
            loginSignUpSectionUi(context)
          ],
        ),
      ),
    );
  }
  Widget logoWithTextUi(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(AppConstant.basePath+AppConstant.smfLogoPath,width: 70,),
        Text(AppConstant.smfPlainText,style: TextStyle(fontSize: 30,color: AppColor.white,fontWeight: FontWeight.bold),)
      ],
    );
  }
  Widget welcomeLogoWithTextUi(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(AppConstant.basePath+AppConstant.welcomeLogoPath,width: 200,),
          SizedBox(height: 40,),
          Text(AppConstant.surahBayinahArabicPlainText,style: TextStyle(fontSize: 15,color: AppColor.downy,fontWeight: FontWeight.bold),),
          Text(AppConstant.surahBayinahBanglaTranslationPlainText,style: TextStyle(fontSize: 20,color: AppColor.white),textAlign: TextAlign.center),
          Text(AppConstant.surahBayinahPlainText,style: TextStyle(fontSize: 10,color: AppColor.grannySmith),),
        ],
      ),
    );
  }
  Widget loginSignUpSectionUi(BuildContext context){
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomButton(content: AppConstant.loginPlainText,contentColor: AppColor.timberGreen,
            backgroundColor: AppColor.white,
            onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
        }),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppConstant.donotHaveAccountPlainText,style: TextStyle(color: AppColor.grannySmith),),
            SizedBox(width: 10,),
            InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupScreen()));
                },
                child: Text(AppConstant.signUpPlainText,style: TextStyle(color: AppColor.white,fontWeight: FontWeight.bold),)),
          ],
        )
        ],
    );
  }
}
