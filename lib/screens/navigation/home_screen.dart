
import 'package:flutter/material.dart';

import '../../utils/color/app_color.dart';
import '../../utils/extension/theme.dart';
import '../../utils/values/app_constant.dart';
import 'home/business/account_screen.dart';
import 'home/blood_donation_directory_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.aquaHaze,
        body: ListView(
          padding: EdgeInsets.all(10),
          children: [
            CustomTile(title: AppConstant.accountPlainText,imagePath: AppConstant.basePath+AppConstant.accountLogoPath,onTapAction: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountScreen()));
            }),
            SizedBox(height: 10,),
            CustomTile(title: AppConstant.bloodDonationDirectoryPlainText,imagePath: AppConstant.basePath+AppConstant.bloodDonationLogoPath,onTapAction: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>BloodDonorDirectoryScreen()));
            }),
            SizedBox(height: 10,),
            CustomTile(title: AppConstant.manPowerListPlainText,imagePath: AppConstant.basePath+AppConstant.manPowerLogoPath,onTapAction: (){}),
          ],
        )
    );
  }
}