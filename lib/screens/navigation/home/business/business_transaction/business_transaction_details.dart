import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smf/models/entry_details_model.dart';
import 'package:smf/utils/color/app_color.dart';
import 'package:smf/utils/functionalities/functions.dart';
import 'package:smf/utils/values/app_constant.dart';

import '../../../../../models/transaction_model.dart';
import '../../../../../utils/extension/theme.dart';
import 'add_new_transaction_entry_screen.dart';

class BusinessTransactionDetailsScreen extends StatefulWidget {
  BusinessTransactionDetailsScreen(
      {super.key,
      required this.selectedTransaction,
      required this.path});
  TransactionModel selectedTransaction;
  String path;

  @override
  State<BusinessTransactionDetailsScreen> createState() =>
      _BusinessTransactionDetailsScreenState();
}

class _BusinessTransactionDetailsScreenState
    extends State<BusinessTransactionDetailsScreen> {
  Map<String, String> groupMap = {};

  bool loadData = true;
  DateTime startDate = DateTime(1950);
  DateTime endDate = DateTime.now();

  Future<List<EntryDetailsModel>>? _getEntriesFuture;
  List<EntryDetailsModel> entries = [];
  List<EntryDetailsModel> filteredEntries = [];
  double totalExpense = 0, totalIncome = 0, remainingBalance = 0;

  Future<List<EntryDetailsModel>> getEntryDetails() async {
    print('Initiated:${GlobalVar.basePath}');
    print('Path:${widget.path}');
    FirebaseDatabase database = FirebaseDatabase.instance;

    //database.ref("${AppConstant.manPowerGroupPath}/${groupNameController.text}/people0");
    DatabaseReference ref =
        database.ref("${widget.path}/${AppConstant.entryColumnText}");
    //print(ref.);
    entries.clear();
    totalExpense = 0;
    totalIncome = 0;
    remainingBalance = 0;
    await ref.once().then((event) {
      if (event.snapshot.exists) {
        // Extract the data as a Map
        Map<dynamic, dynamic> groupData =
            event.snapshot.value as Map<dynamic, dynamic>;
        for (var key in groupData.keys) {
          // print('After getting a key, the value is ${groupData[key]}');
          setState(() {
            if(startDate.isBefore(DateTime.parse(groupData[key][AppConstant.entryDateColumnText].toString())) && endDate.isAfter(DateTime.parse(groupData[key][AppConstant.entryDateColumnText].toString()))){
              entries.add(EntryDetailsModel(
                entryTitle:
                groupData[key][AppConstant.entryTitleColumnText].toString(),
                entryDetails:
                groupData[key][AppConstant.entryDetailsColumnText].toString(),
                transactionDate:
                groupData[key][AppConstant.entryDateColumnText].toString(),
                amount:
                groupData[key][AppConstant.entryAmountColumnText].toString(),
                isDebit: groupData[key][AppConstant.debitOrCreditColumnText],
              ));
              if (entries.last.isDebit) {
                totalExpense += double.parse(entries.last.amount);
              } else {
                totalIncome += double.parse(entries.last.amount);
              }
              remainingBalance = totalIncome - totalExpense;
            }
          });
        }
        // print('Group Map:$groupMap');
      } else {
        print("Group with ID '123' does not exist.");
      }
    });

    entries.sort(
      (a, b) => a.transactionDate.compareTo(b.transactionDate),
    );
    print('');
    return entries;
  }

  @override
  void initState() {
    if (loadData) {
      _getEntriesFuture = getEntryDetails();
    }
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
              const SizedBox(
                height: 10,
              ),
              initReportUi(),
              const SizedBox(
                height: 10,
              ),
              initEntryTitleUi(),
              const SizedBox(
                height: 10,
              ),
            ],
          )
        ),
      ),
    );
  }

  Widget initBusinessTransactionDetailsTitleUi() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        // Container(
        //   padding: EdgeInsets.all(10),
        //   height: 50,
        //   width: 50,
        //   decoration: BoxDecoration(
        //           shape: BoxShape.circle,
        //           color: AppColor.white,
        //           borderRadius: BorderRadius.circular(5)),
        // ),
        // const SizedBox(
        //   width: 10,
        // ),
        Flexible(
            child: BusinessTitleWithIcon(
          title: widget.selectedTransaction.transactionName,
        ))
      ],
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
                                  // filteredEntries.clear();
                                  // totalIncome = 0;
                                  // totalExpense = 0;
                                  // for (var entry in entries) {
                                  //   print(
                                  //       'Entry date is : ${DateTime.parse(entry.transactionDate)}');
                                  //   if (startDate.isBefore(DateTime.parse(
                                  //           entry.transactionDate)) &&
                                  //       endDate.isAfter(DateTime.parse(
                                  //           entry.transactionDate))) {
                                  //     filteredEntries.add(entry);
                                  //     if (filteredEntries.last.isDebit) {
                                  //       totalExpense += double.parse(
                                  //           filteredEntries.last.amount);
                                  //     } else {
                                  //       totalIncome += double.parse(
                                  //           filteredEntries.last.amount);
                                  //     }
                                  //   }
                                  // }
                                  // remainingBalance = totalIncome - totalExpense;
                                  // print(
                                  //     'Filtered length:${filteredEntries.length}');
                                });
                              },
                              saveFunction: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                _getEntriesFuture = getEntryDetails();
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

  Widget initEntryTitleUi() {
    return TitleIconButtonWithWhiteBackground(
        headline: AppConstant.entryTitlePlainText,
        actionIcon: Icons.add,
        action: () async {
          loadData = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddNewBusinessTransactionEntryScreen(
                        path: widget.path,
                        selectedTransaction: widget.selectedTransaction,
                      )));
          if (loadData) {
            setState(() {
              _getEntriesFuture = getEntryDetails();
            });
          }
        },
        whatToShow: FutureBuilder<List<EntryDetailsModel>>(
          future: _getEntriesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Please add some transactions..'));
            } else if (snapshot.data!.isEmpty) {
              return Text('Please add some transactions');
            } else {
              // filteredEntries = entries;
              filteredEntries.clear();
              for(var entry in entries){
                if(startDate.isBefore(DateTime.parse(entry.transactionDate))&& endDate.isAfter(DateTime.parse(entry.transactionDate))){
                  filteredEntries.add(entry);
                }
                print('object');
              }
              return Table(
                border: TableBorder.all(
                    color: AppColor.nebula,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5))),
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
                          child: Text(AppConstant.datePlainText,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(AppConstant.productNamePlainText,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            AppConstant.moneyAmountPlainText,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ]),
                  ...filteredEntries.where((element) => startDate.isBefore(DateTime.parse(element.transactionDate))&& endDate.isAfter(DateTime.parse(element.transactionDate)))
                      .map((e) => TableRow(children: [
                    Text(e.transactionDate,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15)),
                    Text(e.entryTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(e.isDebit ? '-' : '+',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15,
                                color: e.isDebit
                                    ? AppColor.red
                                    : AppColor.green)),
                        Text(e.amount,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15))
                      ],
                    ),
                  ]))
                      .toList()
                ],
              );
            }
          },
        )
    );
  }
}
