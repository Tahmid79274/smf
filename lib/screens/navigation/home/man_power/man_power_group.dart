import 'package:flutter/material.dart';

import '../../../../utils/color/app_color.dart';
import '../../../../utils/extension/theme.dart';
import '../../../../utils/values/app_constant.dart';
import 'add_man_power_screen.dart';
import 'man_power_list_screen.dart';

class ManPowerGroupScreen extends StatefulWidget {
  const ManPowerGroupScreen({super.key});

  @override
  State<ManPowerGroupScreen> createState() => _ManPowerGroupScreenState();
}

class _ManPowerGroupScreenState extends State<ManPowerGroupScreen> {
  @override
  Widget build(BuildContext context) {
    return BasicAquaHazeBGUi(
      appBarTitle: AppConstant.manPowerListPlainText,
      child: initBuildUi(),
    );
  }

  Widget initBuildUi(){
    return Column(
      children: [
        initSearchAndAddAccountUi(),
        const SizedBox(height: 10,),
        initManPowerGroupUi()
      ],
    );
  }

  Widget initSearchAndAddAccountUi(){
    return TextFormField(
      decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          suffixIcon: Icon(Icons.search,color: AppColor.alto,),
          hintText: AppConstant.searchPlainText,
          hintStyle: TextStyle(color: AppColor.alto),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.aquaHaze)
          )
      ),
    );
  }

  Widget initManPowerGroupUi(){
    return TitleIconButtonWithWhiteBackground(
      headline: AppConstant.manpowerGroupListPlainText,
      actionIcon: Icons.add,
      action: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>AddManpowerScreen()));
      },
      whatToShow: GridView(
        physics: AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,crossAxisSpacing: 10,mainAxisSpacing: 10,childAspectRatio: 1),
        children: [
          CardAquaHazeWithColumnIconAndTitle(
            title: 'রেজা ওভারসিস',
            action: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ManPowerGroupListScreen()));
            },
          ),
          CardAquaHazeWithColumnIconAndTitle(
            title: 'রেজা ওভারসিস',
            action: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ManPowerGroupListScreen()));
            },
          ),
          CardAquaHazeWithColumnIconAndTitle(
            title: 'রেজা ওভারসিস',
            action: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ManPowerGroupListScreen()));
            },
          ),
          CardAquaHazeWithColumnIconAndTitle(
            title: 'রেজা ওভারসিস',
            action: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ManPowerGroupListScreen()));
            },
          ),
          CardAquaHazeWithColumnIconAndTitle(
            title: 'রেজা ওভারসিস',
            action: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ManPowerGroupListScreen()));
            },
          ),
          CardAquaHazeWithColumnIconAndTitle(
            title: 'রেজা ওভারসিস',
            action: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ManPowerGroupListScreen()));
            },
          ),
        ],
      ),
    );
  }
}
