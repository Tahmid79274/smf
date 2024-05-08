import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:smf/models/account_model.dart';
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
  List<AccountModel> accountList = [];
  Map<String, String> groupMap = {};

  Future<List<AccountModel>>? getAccountList;

  Future<List<AccountModel>> getAccounts() async {
    print('Initiated');
    FirebaseDatabase database = FirebaseDatabase.instance;

    DatabaseReference ref = database.ref("${AppConstant.accountPath}/");
    //print(ref.);
    accountList.clear();
    await ref.once().then((event) {
      if (event.snapshot.exists) {
        // Extract the data as a Map
        Map<dynamic, dynamic> groupData =
            event.snapshot.value as Map<dynamic, dynamic>;
        //print('Group Data:$groupData');
        for (var key in groupData.keys) {
          //print('After getting a key, the value is ${groupData[key]}');
          setState(() {
            accountList.add(AccountModel(
                key: key,
                companyName: groupData[key][AppConstant.companyNameColumnText]
                    .toString(),
                address:
                    groupData[key][AppConstant.addressColumnText].toString(),
                ownershipName:
                    groupData[key][AppConstant.ownershipColumnText].toString(),
                imageUrl: groupData[key][AppConstant.businessLogoColumnText]
                    .toString(),
                ));
            //groups.add(key);
          });
        }
      } else {
        print("Group with ID '123' does not exist.");
      }
    });
    return accountList;
  }

  @override
  void initState() {
    getAccountList = getAccounts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.aquaHaze,
      appBar: CustomAppBar(title: AppConstant.accountPlainText),
      body: initBuildUi(),
    );
  }

  Widget initBuildUi() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          initSearchAndAddAccountUi(),
          SizedBox(
            height: 10,
          ),
          initAccountTileList(),
        ],
      ),
    );
  }

  Widget initSearchAndAddAccountUi() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
            child: TextFormField(
          decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              suffixIcon: Icon(
                Icons.search,
                color: AppColor.alto,
              ),
              hintText: AppConstant.searchPlainText,
              hintStyle: TextStyle(color: AppColor.alto),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.alto))),
        )),
        SizedBox(
          width: 10,
        ),
        AddEntryButtonUi(
          whatToDo: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddBusinessScreen()));
          },
        )
      ],
    );
  }

  Widget initAccountTileList() {
    return Expanded(
      child: FutureBuilder<List<AccountModel>>(
        future: getAccountList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return GridView.builder(
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: AlwaysScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.5),
              itemBuilder: (context, index) {
                return MyBusinessTileUi(
                  title: snapshot.data![index].companyName,
                  imagePath: snapshot.data![index].imageUrl,
                  context: context,
                  onTapAction: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                BusinessAccountInformationScreen(selectedBusinessAccount: snapshot.data![index],
                                path: '${AppConstant.accountPath}/${snapshot.data![index].key}',
                                )));
                  },
                  editAction: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddBusinessScreen(
                                  editCompanyInfo: snapshot.data![index],
                                )));
                  },
                  deleteAction: () async {
                    showDialog(context: context, builder: (context)=>Center(child: CircularProgressIndicator(),));
                    final desertRef = FirebaseStorage.instance.ref().child("${AppConstant.accountPath}/${snapshot.data![index].key}/${AppConstant.userImageName}");

                    await desertRef.delete();
                    DatabaseReference ref = FirebaseDatabase.instance.ref("${AppConstant.accountPath}/${snapshot.data![index].key}");

                    await ref.remove();
                    setState(() {
                      snapshot.data!.removeAt(index);
                    });
                    Navigator.of(context,rootNavigator: true).pop();
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
