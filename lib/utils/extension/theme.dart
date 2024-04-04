

import 'package:flutter/material.dart';
import '../color/app_color.dart';
import '../values/app_constant.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  CustomAppBar({super.key,required this.title});
  String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.timberGreen,
      iconTheme: IconThemeData(color: AppColor.white),
      elevation: 0,
      title: Text(title,style: TextStyle(color: AppColor.white),),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}


class CustomHeader extends StatelessWidget {
  CustomHeader({super.key,required this.title,required this.subtitle});
  String title,subtitle;

  @override
  Widget build(BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title,style: TextStyle(color: AppColor.sepiaBlack,fontWeight: FontWeight.bold,fontSize: 30),),
          Text(subtitle,style: TextStyle(color: AppColor.dustyGray,fontSize: 20),),
        ],
      );
  }
}


class CustomButton extends StatelessWidget {
  CustomButton({super.key,required this.content, required this.contentColor, required this.backgroundColor,required this.onPressed});
  String content;
  VoidCallback onPressed;
  Color contentColor;
  Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed,
        child: Text(content,style: TextStyle(fontSize:20,fontWeight: FontWeight.bold,color: contentColor),),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
            minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width-40, 40)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))
        )
    );
  }
}

class CustomTile extends StatelessWidget {
  CustomTile({super.key,required this.title,required this.imagePath,required this.onTapAction});
  String title, imagePath;
  VoidCallback onTapAction;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTapAction,
      shape: RoundedRectangleBorder(side: BorderSide(color: AppColor.nebula),borderRadius: BorderRadius.all(Radius.circular(5))),
      contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
      tileColor: AppColor.white,
      leading: Image.asset(imagePath,fit: BoxFit.fill,width: 40),
      title: Text(title,style: TextStyle(color:AppColor.sepiaBlack,fontSize: 20),),
      trailing: Icon(Icons.arrow_forward_ios),
    );
  }
}

class MyBusinessTileUi extends StatelessWidget {
  MyBusinessTileUi({super.key,required this.title,required this.imagePath,required this.context});
  BuildContext context;
  String title, imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: AppColor.white,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          PopupMenuButton(
            padding: EdgeInsets.zero,
            offset: Offset.zero,
            icon: Icon(Icons.more_horiz),
            itemBuilder: (context) {
              return [
                PopupMenuItem(child: Text('Ste')),
              ];
            },),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    color: AppColor.fruitSalad,
                    borderRadius: BorderRadius.circular(50)),
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                // child: Image.asset(AppConstant.basePath+AppConstant.fbLogoPath,alignment: Alignment.center,fit: BoxFit.fill,),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: Text(AppConstant.manPowerListPlainText,style: TextStyle(fontSize: 20),)
              )
            ]
          )
        ],
      ),
    );
  }
}

class AddEntryButtonUi extends StatelessWidget {
  AddEntryButtonUi({super.key,required this.whatToDo});
  VoidCallback whatToDo;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      onPressed: whatToDo, icon: Icon(Icons.add,size: 25,),style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
        side: MaterialStatePropertyAll<BorderSide>(BorderSide(color: AppColor.fruitSalad))),);
  }
}

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({super.key,required this.hint,required this.controller});
  String hint;
  TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.all(10),
          hintText: hint,border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.grey),
          borderRadius: BorderRadius.circular(5))),
    );
  }
}


Text orTextUI()
{
  return Text(AppConstant.orPlainText,style: TextStyle(fontWeight: FontWeight.bold,color: AppColor.sepiaBlack,fontSize: 20),);
}

Widget socialLoginUi(){
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      InkWell(child: Image.asset(AppConstant.basePath+AppConstant.googleLogoPath,width: 50),),
      SizedBox(width: 20,),
      InkWell(child: Image.asset(AppConstant.basePath+AppConstant.fbLogoPath,width: 50),),
    ],
  );
}

Widget forgotPasswordUi(VoidCallback onPressed){
  return Align(alignment: Alignment.centerRight,child: TextButton(
      onPressed: onPressed,
      child: Text(AppConstant.forgotPasswordPlainText,style: TextStyle(color: AppColor.dustyGray,fontSize: 15),textAlign: TextAlign.end)));
}

OutlineInputBorder borderColorAltoRadius5() {
  return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(color: AppColor.alto));
}

Column headerWithTextFormField(String headline,String hintText,TextEditingController controller){
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(headline,style: TextStyle(color: AppColor.sepiaBlack,fontWeight: FontWeight.bold,fontSize: 30)),
      TextFormField(
        controller: controller,
        decoration: InputDecoration(
            hintText: hintText,
            contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 20),
            isDense: false,
            border: borderColorAltoRadius5()),
      ),
    ],
  );
}