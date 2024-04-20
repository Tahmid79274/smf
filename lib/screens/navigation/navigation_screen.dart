import 'package:flutter/material.dart';
import '../../utils/extension/theme.dart';
import '../../utils/values/app_constant.dart';

import '../../utils/color/app_color.dart';
import 'home_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {

  // int currentIndex = 0 ;
  //
  // static const List<Widget> _widgetOptions = <Widget>[
  //   HomeScreen(),
  //   Text('Search Page'),
  //   Text('Profile Page'),
  //   Text('Settings Page'),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.aquaHaze,
      appBar: CustomAppBar(title: ''),
      //body: Center(child: HomeScreen()),
      body: HomeScreen(),
      /*bottomNavigationBar: BottomNavigationBar(
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
      ),*/
    );
  }
}