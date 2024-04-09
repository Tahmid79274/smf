import 'package:flutter/material.dart';

import '../../../../utils/color/app_color.dart';
import '../../../../utils/extension/theme.dart';
import '../../../../utils/values/app_constant.dart';
import 'add_business_screen.dart';
import 'business_transaction/business_transaction_details.dart';

class BusinessAccountInformationScreen extends StatefulWidget {
  const BusinessAccountInformationScreen({super.key});

  @override
  State<BusinessAccountInformationScreen> createState() => _BusinessAccountInformationScreenState();
}

class _BusinessAccountInformationScreenState extends State<BusinessAccountInformationScreen> {
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          initSelectedBusinessTitleUi(),
          const SizedBox(height: 10,),
          initReportUi(),
          const SizedBox(height: 10,),
          initTransactionReportTileUi()
        ],
      ),
    );
  }

  Widget initSelectedBusinessTitleUi(){
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: AppColor.white,),
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
            Expanded(
                child: Text(AppConstant.manPowerListPlainText,style: const TextStyle(fontSize: 20),)
            )
          ]
      ),
    );
  }


  Widget initReportUi(){
    return TitleIconButtonWithWhiteBackground(
      headline: AppConstant.reportPlainText,
      actionIcon: Icons.calendar_today_outlined,
      action: (){},
      whatToShow: Column(children:[
        ReportStatusDetailsUi(title: AppConstant.incomePlainText,amount: '20000',imagePath: AppConstant.incomeLogoPath,),
        const SizedBox(height: 10,),
        ReportStatusDetailsUi(title: AppConstant.expensePlainText,amount: '20000',imagePath: AppConstant.expenseLogoPath,),
        const SizedBox(height: 10,),
        ReportStatusDetailsUi(title: AppConstant.remainingBalancePlainText,amount: '20000',imagePath: AppConstant.remainingBalanceLogoPath,),
      ]),
    );
  }

  Widget initTransactionReportTileUi(){
    return TitleIconButtonWithWhiteBackground(
      headline: AppConstant.accountPlainText,
      actionIcon: Icons.add,
      action: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>AddBusinessScreen()));
      },
      whatToShow: GridView(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),padding: const EdgeInsets.all(10),
      children: [
        CardAquaHazeWithColumnIconAndTitle(title: '',action: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const BusinessTransactionDetailsScreen()));
        }),
        CardAquaHazeWithColumnIconAndTitle(title: '',action: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const BusinessTransactionDetailsScreen()));
        }),
        CardAquaHazeWithColumnIconAndTitle(title: '',action: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const BusinessTransactionDetailsScreen()));
        }),
        CardAquaHazeWithColumnIconAndTitle(title: '',action: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const BusinessTransactionDetailsScreen()));
        }),
        CardAquaHazeWithColumnIconAndTitle(title: '',action: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const BusinessTransactionDetailsScreen()));
        }),
      ],
      ),
    );
  }

}
