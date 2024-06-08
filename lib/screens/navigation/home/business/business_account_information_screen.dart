import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smf/models/account_model.dart';
import 'package:smf/models/entry_details_model.dart';
import 'package:smf/utils/functionalities/functions.dart';

import '../../../../models/transaction_model.dart';
import '../../../../utils/color/app_color.dart';
import '../../../../utils/extension/theme.dart';
import '../../../../utils/functionalities/shared_prefs_manager.dart';
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

  DateTime startDate = DateTime(1950);
  DateTime endDate = DateTime.now();

  double totalIncome = 0, totalExpense = 0, remainingBalance = 0;
  List<TransactionModel> transactionList = [];
  Future<List<TransactionModel>>? _transactionTabsFuture;
  Future<List<TransactionModel>> getTransactionTabsList() async {
    print('Initiated:${GlobalVar.basePath}');
    FirebaseDatabase database = FirebaseDatabase.instance;

    //database.ref("${AppConstant.manPowerGroupPath}/${groupNameController.text}/people0");
    DatabaseReference ref = database.ref(
        "${GlobalVar.basePath}/${AppConstant.accountPath}/${widget.selectedBusinessAccount.key}");
    //print(ref.);
    transactionList.clear();
    totalIncome = 0;
    totalExpense = 0;
    remainingBalance = 0;
    await ref.once().then((event) {
      if (event.snapshot.exists) {
        // Extract the data as a Map
        Map<dynamic, dynamic> groupData =
            event.snapshot.value as Map<dynamic, dynamic>;
        // print('Business Account map:$groupData');
        for (var key in groupData.keys) {
          if (key == AppConstant.transactionsColumnText) {
            setState(() {
              // print('Business Account Key with elements:${groupData[key]}');
              List<EntryDetailsModel> entryList = [];
              for (var transactionKey in groupData[key].keys) {
                // print('Transaction Keys are:$transactionKey');
                // print(
                //     '$transactionKey has:${groupData[key][transactionKey][AppConstant.entryColumnText]}');
                // print('Entry Key:${groupData[key][transactionKey][AppConstant.entryColumnText].length}');
                if(groupData[key][transactionKey][AppConstant.entryColumnText].isNotEmpty){
                  for (var entryKey in groupData[key][transactionKey]
                  [AppConstant.entryColumnText]
                      .keys) {
                    //print('Entry:${groupData[key][transactionKey][AppConstant.entryColumnText][entryKey][AppConstant.entryTitleColumnText]}');
                    entryList.add(EntryDetailsModel(
                        entryTitle: groupData[key][transactionKey]
                        [AppConstant.entryColumnText][entryKey]
                        [AppConstant.entryTitleColumnText]
                            .toString(),
                        entryDetails: groupData[key][transactionKey]
                        [AppConstant.entryColumnText][entryKey]
                        [AppConstant.entryDetailsColumnText]
                            .toString(),
                        transactionDate: groupData[key][transactionKey]
                        [AppConstant.entryColumnText][entryKey]
                        [AppConstant.entryDateColumnText]
                            .toString(),
                        amount: groupData[key][transactionKey]
                        [AppConstant.entryColumnText][entryKey]
                        [AppConstant.entryAmountColumnText]
                            .toString(),
                        isDebit: groupData[key][transactionKey]
                        [AppConstant.entryColumnText][entryKey]
                        [AppConstant.debitOrCreditColumnText]));
                    // print('${entryList.last.entryTitle} is a ${entryList.last.isDebit}');
                  }
                }
                // print('Transaction is ${groupData[key][transactionKey][AppConstant.nameColumnText]}');

                try {
                  transactionList.add(TransactionModel(
                                      key: transactionKey,
                                      transactionName: groupData[key][transactionKey]
                                              [AppConstant.nameColumnText]
                                          .toString(),
                                      income: groupData[key][transactionKey]
                                              [AppConstant.incomeColumnText]
                                          .toString(),
                                      expense: groupData[key][transactionKey]
                                              [AppConstant.incomeColumnText]
                                          .toString(),
                                      remainingBalance: groupData[key][transactionKey]
                                              [AppConstant.incomeColumnText]
                                          .toString(),
                                      entries: entryList));
                } catch (e) {
                  print(e);
                }
                print('Before length:${transactionList.last.entries.length}');
                entryList= [];
                print('After length:${transactionList.last.entries.length}');
              }
            });
          }
        }
        // print('Transactions:$transactionList');
      } else {
        //print("Group with ID '123' does not exist.");
      }
    });
    transactionList.sort(
      (a, b) => a.transactionName.compareTo(b.transactionName),
    );
    for(TransactionModel transactionModel in transactionList){
      if(transactionModel.entries.isNotEmpty){
        for(EntryDetailsModel entry in transactionModel.entries){
          // print('${transactionModel.transactionName} has ${entry.entryTitle} and it is ${entry.isDebit}');
          DateTime entryDate = DateTime.parse(entry.transactionDate);
          // print('Entry date is $entryDate which occurs after $startDate\'s and before $endDate');
          if(entryDate.isAfter(startDate) && entryDate.isBefore(endDate)){
            print('true');
            if (entry.isDebit) {
              totalExpense +=
                  double.parse(entry.amount);
            }
            else {
              totalIncome +=
                  double.parse(entry.amount);
            }
          }
        }
      }
    }
    setState(() {
      remainingBalance = totalIncome -totalExpense;
    });
    print('');
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
      action: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return CustomCalendar(
                  range: 'From',
                  today:
                  '${startDate.year}-${startDate.month}-${startDate.day}',
                  dateChangeFunction: (selectedDate) {
                    setState(() {
                      startDate = selectedDate!.subtract(Duration(days: 1));
                    });
                  },
                  saveFunction: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return CustomCalendar(
                              range: 'Today',
                              today:
                              '${endDate.year}-${endDate.month}-${endDate.day}',
                              dateChangeFunction: (selectedDate) {
                                setState(() {
                                  endDate = selectedDate!.add(Duration(days: 1));
                                });
                              },
                              saveFunction: () {
                                setState((){
                                  totalIncome = 0;
                                  totalExpense = 0;
                                  for(TransactionModel transactionModel in transactionList){
                                    for(EntryDetailsModel entry in transactionModel.entries){
                                      // print('${transactionModel.transactionName} has ${entry.entryTitle} and it is ${entry.isDebit}');
                                      DateTime entryDate = DateTime.parse(entry.transactionDate);
                                      print('Entry date is $entryDate which occurs after $startDate\'s and before $endDate');
                                      if(entryDate.isAfter(startDate) && entryDate.isBefore(endDate)){
                                        if (entry.isDebit) {
                                          totalExpense +=
                                              double.parse(entry.amount);
                                        }
                                        else {
                                          totalIncome +=
                                              double.parse(entry.amount);
                                        }
                                      }
                                    }
                                  }

                                  remainingBalance = totalIncome - totalExpense;
                                  print('Income:$totalIncome,Expense:$totalExpense,bal:$remainingBalance');
                                });
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                _transactionTabsFuture = getTransactionTabsList();
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
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
                        AppConstant.nameColumnText:
                            transactionDetailsTabController.text,
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
            print('The error is ${snapshot.error}');
            return Text('Please add transaction..');
          } else if (snapshot.data!.isEmpty) {
            return Text('Please add transaction');
          } else {
            return GridView.builder(
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10),
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                int digit = index+1;
                return CardAquaHazeWithColumnIconAndTitle(
                  longPressAction: (){},
                    title: '${GlobalVar.englishNumberToBengali(digit.toString())}.${snapshot.data![index].transactionName}',
                    action: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  BusinessTransactionDetailsScreen(
                                    path:
                                        '${widget.path}/${AppConstant.transactionsColumnText}/${snapshot.data![index].key}',
                                    selectedTransaction: snapshot.data![index],
                                  ))).whenComplete(() {
                        _transactionTabsFuture = getTransactionTabsList();
                      });
                    });
              },
            );
          }
        },
      ),
    );
  }
}
