import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:smf/utils/extension/theme.dart';

import '../../../../../../utils/color/app_color.dart';
import '../../../../../../utils/values/app_constant.dart';
import 'add_business_screen.dart';
import 'business_account_information_screen.dart';

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
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            suffixIcon: Icon(Icons.search,color: AppColor.alto,),
            hintText: AppConstant.searchPlainText,
            hintStyle: TextStyle(color: AppColor.alto),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.alto)
            )
          ),
        )),
        SizedBox(width: 10,),
        AddEntryButtonUi(whatToDo: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddBusinessScreen()));
        },)
      ],
    );
  }
  
  Widget initAccountTileList(){
    return Expanded(
      child: GridView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: AlwaysScrollableScrollPhysics(),

        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 10,mainAxisSpacing: 10,childAspectRatio: 1.5),
      children: [
        MyBusinessTileUi(title: 'Text',imagePath: 'text',context: context,onTapAction: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>BusinessAccountInformationScreen()));
        }),
        MyBusinessTileUi(title: 'Text',imagePath: 'text',context: context,onTapAction: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>BusinessAccountInformationScreen()));
        }),
        MyBusinessTileUi(title: 'Text',imagePath: 'text',context: context,onTapAction: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>BusinessAccountInformationScreen()));
        }),
        MyBusinessTileUi(title: 'Text',imagePath: 'text',context: context,onTapAction: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>BusinessAccountInformationScreen()));
        }),
        MyBusinessTileUi(title: 'Text',imagePath: 'text',context: context,onTapAction: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>BusinessAccountInformationScreen()));
        }),
        MyBusinessTileUi(title: 'Text',imagePath: 'text',context: context,onTapAction: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>BusinessAccountInformationScreen()));
        }),
        MyBusinessTileUi(title: 'Text',imagePath: 'text',context: context,onTapAction: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>BusinessAccountInformationScreen()));
        }),
        MyBusinessTileUi(title: 'Text',imagePath: 'text',context: context,onTapAction: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>BusinessAccountInformationScreen()));
        }),
      ],
      ),
    );
  }
}


