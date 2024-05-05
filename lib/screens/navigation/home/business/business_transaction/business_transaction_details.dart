import 'package:flutter/material.dart';
import 'package:smf/utils/color/app_color.dart';
import 'package:smf/utils/values/app_constant.dart';

import '../../../../../models/transaction_model.dart';
import '../../../../../utils/extension/theme.dart';
import 'add_new_transaction_entry_screen.dart';

class BusinessTransactionDetailsScreen extends StatefulWidget {
  BusinessTransactionDetailsScreen({super.key,required this.selectedTransactionKey,required this.path,required this.imageUrl});
  String selectedTransactionKey;
  String path,imageUrl;

  @override
  State<BusinessTransactionDetailsScreen> createState() => _BusinessTransactionDetailsScreenState();
}

class _BusinessTransactionDetailsScreenState extends State<BusinessTransactionDetailsScreen> {
  @override
  void initState(){
    print('Selected path:${widget.path}');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BasicAquaHazeBGUi(
      appBarTitle: AppConstant.accountPlainText,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              initBusinessTransactionDetailsTitleUi(),
              const SizedBox(height: 10,),
              initReportUi(),
              const SizedBox(height: 10,),
              initEntryTitleUi(),
              const SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }

  Widget initBusinessTransactionDetailsTitleUi(){
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          height: 50,
          width: 50,
          decoration: widget.imageUrl.isEmpty?BoxDecoration(
            shape: BoxShape.circle,
              color: AppColor.white,
            borderRadius: BorderRadius.circular(5)
          ):
          BoxDecoration(
              shape: BoxShape.circle,
            image: DecorationImage(image: NetworkImage(widget.imageUrl),fit: BoxFit.fill)
          ),
          child: Text(widget.selectedTransactionKey.transactionName),
        ),
        const SizedBox(width: 10,),
        Flexible(child: BusinessTitleWithIcon(title: widget.selectedTransactionKey.transactionName,))
      ],
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

  List<String> test =['20','30','40','20','30','40','20','30','40','20','30','40','20','30','40','20','30','40','20','30','40','20','30','40',];
  Widget initEntryTitleUi(){
    return TitleIconButtonWithWhiteBackground(
      headline: AppConstant.entryTitlePlainText,
      actionIcon: Icons.add,
      action: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>AddNewBusinessTransactionEntryScreen()));
      },
      whatToShow: Table(
        border: TableBorder.all(
            color: AppColor.nebula,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5))),
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: AppColor.aquaHaze,
              // border: Border.all(color: AppColor.grey),
              // borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5))
            ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(AppConstant.datePlainText,textAlign: TextAlign.center,style: TextStyle(fontSize: 15)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(AppConstant.productNamePlainText,textAlign: TextAlign.center,style: TextStyle(fontSize: 15)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(AppConstant.moneyAmountPlainText,textAlign: TextAlign.center,style: TextStyle(fontSize: 15),),
                ),
          ]),
          ...test.map((e) => TableRow(
            children: [
              Text(e,textAlign: TextAlign.center,style: TextStyle(fontSize: 15)),
              Text(e,textAlign: TextAlign.center,style: TextStyle(fontSize: 15)),
              Text(e,textAlign: TextAlign.center,style: TextStyle(fontSize: 15)),
            ]
          )).toList()
        ],
      ),
    );
  }

}
