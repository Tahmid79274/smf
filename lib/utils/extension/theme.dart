

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
  MyBusinessTileUi({super.key,required this.title,required this.imagePath,required this.context,required this.onTapAction});
  BuildContext context;
  String title, imagePath;
  VoidCallback onTapAction;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapAction,
      child: Container(
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
              color: AppColor.white,
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                      child: Row(
                    children: [
                      Icon(Icons.edit_note,color: AppColor.killarney,),
                      SizedBox(width: 10,),
                      Text(AppConstant.editPlainText,style: TextStyle(color: AppColor.killarney)),
                    ],
                  )),
                  PopupMenuItem(
                      child: Row(
                    children: [
                      Icon(Icons.delete,color: AppColor.butterCup,),
                      SizedBox(width: 10,),
                      Text(AppConstant.removePlainText,style: TextStyle(color: AppColor.butterCup),),
                    ],
                  )),
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
  CustomTextFormField({super.key,required this.hint,required this.controller,this.onTap});
  String hint;
  TextEditingController controller;
  VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
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

class BasicAquaHazeBGUi extends StatelessWidget {
  BasicAquaHazeBGUi({super.key,required this.appBarTitle,required this.child});
  String appBarTitle;
  Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.aquaHaze,
      appBar: CustomAppBar(title: appBarTitle),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: child,
      ),
    );
  }
}

class ReportStatusDetailsUi extends StatelessWidget {
  ReportStatusDetailsUi({super.key,required this.title,required this.amount,required this.imagePath});
  String title,amount,imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: AppColor.grey),
            borderRadius: BorderRadius.all(Radius.circular(5))
        ),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Image.asset(AppConstant.basePath+imagePath,width: 20,),
                    SizedBox(width: 10,),
                    Text(title,style: TextStyle(fontSize: 20),)
                  ],
                ),
              )),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
              height: 45,
              width: 1,
              color: AppColor.grey,
            ),
          Expanded(child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              takaLogo(),
              SizedBox(width: 5,),
              Text(amount,style: TextStyle(fontSize: 20)),
            ],
          )),
        ],
      ),
    );
  }
}

class CardAquaHazeWithColumnIconAndTitle extends StatelessWidget {
  CardAquaHazeWithColumnIconAndTitle({super.key,required this.title,required this.action});
  String title;
  VoidCallback action;

  @override
  Widget build(BuildContext context) {
    return Card(margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: AppColor.aquaHaze,
      child: InkWell(
        onTap: action,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.book,color: AppColor.fruitSalad,),
              SizedBox(height: 10,),
              Text('মালামাল ক্রয়ের হিসাব ',textAlign: TextAlign.center,maxLines: 2,style: TextStyle(fontSize: 17),)
            ],
          ),
        ),
      ),
    );
  }
}


Widget takaLogo(){
  return Image.asset(AppConstant.basePath+AppConstant.takaLogoPath,width: 18,);
}

class TitleIconButtonWithWhiteBackground extends StatelessWidget {
  TitleIconButtonWithWhiteBackground({super.key,required this.headline,required this.actionIcon,required this.whatToShow,required this.action});
  Widget whatToShow;
  String headline;
  IconData actionIcon;
  VoidCallback action;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: AppColor.white,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Text(AppConstant.reportPlainText,style: TextStyle(fontSize: 20),),
                Text(headline,style: TextStyle(fontSize: 20),),
                IconButton(onPressed: action, icon: Icon(actionIcon),style: ButtonStyle(
                  //elevation: MaterialStatePropertyAll(10),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                    side: MaterialStatePropertyAll(BorderSide(color: AppColor.grey))
                ),)
              ]
          ),
          SizedBox(height: 10,),
          whatToShow
        ],
      ),
    );
  }
}

class BusinessTitleWithIcon extends StatelessWidget {
  BusinessTitleWithIcon({super.key,required this.title});
  String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: AppColor.white,),
      child: Row(
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
              padding: const EdgeInsets.all(10),
              // child: Image.asset(AppConstant.basePath+AppConstant.fbLogoPath,alignment: Alignment.center,fit: BoxFit.fill,),
            ),
            const SizedBox(width: 10,),
            Text(title,style: const TextStyle(fontSize: 20),)
          ]
      ),
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