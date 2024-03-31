import 'package:flutter/material.dart';
import 'package:smf/utils/extension/theme.dart';

import '../../../utils/color/app_color.dart';
import '../../../utils/values/app_constant.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.aquaHaze,
      appBar: CustomAppBar(title: AppConstant.accountPlainText),
      body: initBuildUi(),
    );
  }

  Widget initBuildUi(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          initSearchAndAddAccountUi(),
          SizedBox(height: 10,),
          initAccountTileList(),
        ],
      ),
    );
  }

  Widget initSearchAndAddAccountUi(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(child: TextFormField(
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.search,color: AppColor.alto,),
            hintText: AppConstant.searchPlainText,
            hintStyle: TextStyle(color: AppColor.alto),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.alto)
            )
          ),
        )),
        SizedBox(width: 10,),
        IconButton(onPressed: (){}, icon: Icon(Icons.add),style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
            side: MaterialStatePropertyAll<BorderSide>(BorderSide(color: AppColor.fruitSalad))),)
      ],
    );
  }
  
  Widget initAccountTileList(){
    return Expanded(
      child: GridView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: AlwaysScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      children: [
        MyBusinessTileUi(title: 'Text',imagePath: 'text',context: context),
        MyBusinessTileUi(title: 'Text',imagePath: 'text',context: context),
        MyBusinessTileUi(title: 'Text',imagePath: 'text',context: context),
        MyBusinessTileUi(title: 'Text',imagePath: 'text',context: context),
        MyBusinessTileUi(title: 'Text',imagePath: 'text',context: context),
        MyBusinessTileUi(title: 'Text',imagePath: 'text',context: context),
      ],
      ),
    );
  }
}


