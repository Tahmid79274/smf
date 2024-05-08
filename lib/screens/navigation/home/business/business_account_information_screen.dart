import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smf/models/account_model.dart';
import 'package:smf/utils/functionalities/functions.dart';

import '../../../../models/transaction_model.dart';
import '../../../../utils/color/app_color.dart';
import '../../../../utils/extension/theme.dart';
import '../../../../utils/values/app_constant.dart';
import 'business_transaction/business_transaction_details.dart';

class BusinessAccountInformationScreen extends StatefulWidget {
  BusinessAccountInformationScreen(
      {super.key, required this.selectedBusinessAccount, required this.path});
  AccountModel selectedBusinessAccount;
  String path;

  @override
  State<BusinessAccountInformationScreen> createState() =>
      _BusinessAccountInformationScreenState();
}

class _BusinessAccountInformationScreenState
    extends State<BusinessAccountInformationScreen> {
  TextEditingController transactionDetailsTabController =
      TextEditingController();

  double totalIncome=0,totalExpense = 0,remainingBalance =0;
  List<TransactionModel> transactionList = [];
  Future<List<TransactionModel>>? _transactionTabsFuture;
  Future<List<TransactionModel>> getTransactionTabsList() async {
    //print('Initiated');
    FirebaseDatabase database = FirebaseDatabase.instance;

    //database.ref("${AppConstant.manPowerGroupPath}/${groupNameController.text}/people0");
    DatabaseReference ref = database.ref(
        "${AppConstant.accountPath}/${widget.selectedBusinessAccount.key}");
    //print(ref.);
    transactionList.clear();
    totalIncome = 0; totalExpense = 0; remainingBalance =0;
    await ref.once().then((event) {
      if (event.snapshot.exists) {
        // Extract the data as a Map
        Map<dynamic, dynamic> groupData =
            event.snapshot.value as Map<dynamic, dynamic>;
        //print('Business Account map:$groupData');
        for (var key in groupData.keys) {
          if (key == AppConstant.transactionsColumnText) {
            // print('Business Account Key:${groupData[key]}');
            for(var transactionKey in groupData[key].keys){
              print('Transaction Keys are:$transactionKey');
              setState(() {
                totalIncome += double.parse(groupData[key][transactionKey][AppConstant.incomeColumnText].toString());
                totalExpense += double.parse(groupData[key][transactionKey][AppConstant.expenseColumnText].toString());
                remainingBalance = totalIncome - totalExpense;
                transactionList.add(TransactionModel(
                    key: transactionKey,
                    transactionName: groupData[key][transactionKey][AppConstant.nameColumnText].toString(),
                    income:
                    groupData[key][transactionKey][AppConstant.incomeColumnText].toString(),
                    expense: groupData[key][transactionKey][AppConstant.incomeColumnText].toString(),
                    remainingBalance: groupData[key][transactionKey][AppConstant.incomeColumnText].toString(),
                    entries: []));
              });
            }
          }
        }

        //print('Transactions:$transactionList');
      } else {
        //print("Group with ID '123' does not exist.");
      }
    });
    return transactionList;
  }

  @override
  void initState() {
    print('Path:${widget.path}');
    _transactionTabsFuture = getTransactionTabsList();
    super.initState();
  }

  @override
  void dispose() {
    transactionDetailsTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.aquaHaze,
      appBar: CustomAppBar(title: AppConstant.accountPlainText),
      body: SingleChildScrollView(child: initBuildUi()),
    );
  }

  Widget initBuildUi() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          initSelectedBusinessTitleUi(),
          const SizedBox(
            height: 10,
          ),
          initReportUi(),
          const SizedBox(
            height: 10,
          ),
          initTransactionReportTileUi()
        ],
      ),
    );
  }

  Widget initSelectedBusinessTitleUi() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColor.white,
      ),
      child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: widget.selectedBusinessAccount.imageUrl.isNotEmpty
                  ? BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(
                            widget.selectedBusinessAccount.imageUrl,
                          ),
                          fit: BoxFit.fill))
                  : BoxDecoration(
                      color: AppColor.fruitSalad,
                      borderRadius: BorderRadius.circular(50)),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              // child: Image.asset(AppConstant.basePath+AppConstant.fbLogoPath,alignment: Alignment.center,fit: BoxFit.fill,),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: Text(
              widget.selectedBusinessAccount.companyName,
              style: const TextStyle(fontSize: 20),
            ))
          ]),
    );
  }

  Widget initReportUi() {
    return TitleIconButtonWithWhiteBackground(
      headline: AppConstant.reportPlainText,
      actionIcon: Icons.calendar_today_outlined,
      action: () {},
      whatToShow: Column(children: [
        ReportStatusDetailsUi(
          title: AppConstant.incomePlainText,
          amount: totalIncome.toString(),
          imagePath: AppConstant.incomeLogoPath,
        ),
        const SizedBox(
          height: 10,
        ),
        ReportStatusDetailsUi(
          title: AppConstant.expensePlainText,
          amount: totalExpense.toString(),
          imagePath: AppConstant.expenseLogoPath,
        ),
        const SizedBox(
          height: 10,
        ),
        ReportStatusDetailsUi(
          title: AppConstant.remainingBalancePlainText,
          amount: remainingBalance.toString(),
          imagePath: AppConstant.remainingBalanceLogoPath,
        ),
      ]),
    );
  }

  Widget initTransactionReportTileUi() {
    return TitleIconButtonWithWhiteBackground(
      headline: AppConstant.accountPlainText,
      actionIcon: Icons.add,
      action: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                  '${AppConstant.accountPlainText} ${AppConstant.addPlainText}'),
              content: TextFormField(
                controller: transactionDetailsTabController,
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          });
                      String transactionTabName = GlobalVar.customNameEncoder(
                          transactionDetailsTabController.text);
                      print('Transaction Name is: $transactionTabName');
                      FirebaseDatabase database = FirebaseDatabase.instance;

                      DatabaseReference ref = database.ref(
                          "${widget.path}/${AppConstant.transactionsColumnText}/$transactionTabName");

                      await ref.set({
                        AppConstant.nameColumnText: transactionDetailsTabController.text,
                        AppConstant.incomeColumnText: '0',
                        AppConstant.expenseColumnText: '0',
                        AppConstant.remainingBalanceColumnText: '0',
                        AppConstant.entryColumnText: '',

                      });
                      _transactionTabsFuture = getTransactionTabsList();
                      Navigator.of(context, rootNavigator: true).pop();
                      Navigator.of(context, rootNavigator: true).pop();
                      transactionDetailsTabController.clear();
                      print('');
                    },
                    child: Text(AppConstant.addPlainText))
              ],
            );
          },
        );
      },
      whatToShow: FutureBuilder<List<TransactionModel>>(
        future: _transactionTabsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Please add transaction..');
          } else if (snapshot.data!.isEmpty) {
            return Text('Please add transaction');
          }else {
            return GridView.builder(
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10),
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                return CardAquaHazeWithColumnIconAndTitle(
                    title: snapshot.data![index].transactionName,
                    action: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  BusinessTransactionDetailsScreen(
                                    path: '${widget.path}/${AppConstant.transactionsColumnText}/${snapshot.data![index].key}',
                                    selectedTransaction: snapshot.data![index],
                                    imageUrl: widget.selectedBusinessAccount.imageUrl,
                                  )));
                    });
              },
            );
          }
        },
      ),
    );
  }
}
