
import 'package:flutter/material.dart';

import '../../utils/color/app_color.dart';
import '../../utils/extension/theme.dart';
import '../../utils/values/app_constant.dart';
import 'home/business/account_screen.dart';
import 'home/blood_donation/blood_donor_directory_screen.dart';
import 'home/man_power/man_power_group.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BasicAquaHazeBGUi(
      appBarTitle: '',
        //backgroundColor: AppColor.aquaHaze,
        child: ListView(
          //padding: EdgeInsets.all(10),
          children: [
            CustomTile(title: AppConstant.accountPlainText,imagePath: AppConstant.imageBasePath+AppConstant.accountLogoPath,onTapAction: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountScreen()));
            }),
            SizedBox(height: 10,),
            CustomTile(title: AppConstant.bloodDonationDirectoryPlainText,imagePath: AppConstant.imageBasePath+AppConstant.bloodDonationLogoPath,onTapAction: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>BloodDonorDirectoryScreen()));
            }),
            SizedBox(height: 10,),
            CustomTile(title: AppConstant.manPowerListPlainText,imagePath: AppConstant.imageBasePath+AppConstant.manPowerLogoPath,onTapAction: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ManPowerGroupScreen()));
            }),
          ],
        )
    );
  }
}