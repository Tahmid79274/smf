import 'package:flutter/material.dart';
import '../../utils/extension/theme.dart';
import '../../utils/values/app_constant.dart';

import '../../utils/color/app_color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int currentIndex = 0 ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.aquaHaze,
      appBar: customAppBar(),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          CustomTile(title: AppConstant.accountPlainText,imagePath: AppConstant.basePath+AppConstant.accountLogoPath,onTapAction: (){}),
          SizedBox(height: 10,),
          CustomTile(title: AppConstant.bloodDonationDirectoryPlainText,imagePath: AppConstant.basePath+AppConstant.bloodDonationLogoPath,onTapAction: (){}),
          SizedBox(height: 10,),
          CustomTile(title: AppConstant.manPowerListPlainText,imagePath: AppConstant.basePath+AppConstant.manPowerLogoPath,onTapAction: (){}),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            currentIndex=value;
          });
        },
        currentIndex: currentIndex,
        backgroundColor: AppColor.timberGreen,
        selectedItemColor: AppColor.white,
        unselectedItemColor: AppColor.blueSmoke,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home,),label: '',backgroundColor: AppColor.timberGreen,),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard),label: '',backgroundColor: AppColor.timberGreen,),
          BottomNavigationBarItem(icon: Icon(Icons.person),label: '',backgroundColor: AppColor.timberGreen,),
          BottomNavigationBarItem(icon: Icon(Icons.search),label: '',backgroundColor: AppColor.timberGreen,),
        ],
      ),
    );
  }
}
