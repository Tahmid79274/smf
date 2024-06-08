import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../../../models/blood_donor_model.dart';
import '../../../../utils/extension/theme.dart';
import '../../../../utils/color/app_color.dart';
import '../../../../utils/values/app_constant.dart';
import './add_blood_donor_screen.dart';
import '../../../../utils/functionalities/functions.dart';

class BloodDonorDirectoryScreen extends StatefulWidget {
  const BloodDonorDirectoryScreen({super.key});

  @override
  State<BloodDonorDirectoryScreen> createState() =>
      _BloodDonorDirectoryScreenState();
}

class _BloodDonorDirectoryScreenState extends State<BloodDonorDirectoryScreen> {
  TextEditingController searchController = TextEditingController();

  bool loadData = true;
  bool showSuggestion = false;
  bool showLoading = false;
  //int totalDonor = 0;
  List<String> filteredBloodGroupWithLocation = [];
  List<String> bloodGroupList = [
    'A',
    'AB',
    'B',
    '0',
  ];
  String selectedBloodGroup = '';
  List<String> rhFactorList = ['+', '-'];
  String selectedRhFactor = '';

  double height = 0;
  double width = 0;
  int divisionFactor = 3;

  List<BloodDonorModel> bloodDonorList = [];
  List<BloodDonorModel> filteredBloodDonorList = [];
  List<BloodDonorModel> searchFilteredBloodDonorList = [];
  Map<String, String> groupMap = {};

  Future<List<BloodDonorModel>>? donorList;

  Future<List<BloodDonorModel>> getSearchedBloodDonorList() async {
    searchFilteredBloodDonorList = bloodDonorList
        .where((element) => element.name.toLowerCase().contains(searchController.text))
        .toList();
    return searchFilteredBloodDonorList;
  }

  Future<List<BloodDonorModel>> getFilteredBloodDonorList() async {
     if (selectedBloodGroup.isNotEmpty &&
        selectedRhFactor.isNotEmpty) {
      filteredBloodDonorList = bloodDonorList
          .where(
            (element) =>
                element.bloodGroup == selectedBloodGroup &&
                element.rhFactor == selectedRhFactor
          )
          .toList();
      return filteredBloodDonorList;
    } else if (selectedBloodGroup.isNotEmpty ) {
      filteredBloodDonorList = bloodDonorList
          .where(
              (element) =>
          element.bloodGroup == selectedBloodGroup
      )
          .toList();
      return filteredBloodDonorList;
    } else if (selectedRhFactor.isNotEmpty) {
      filteredBloodDonorList = bloodDonorList
          .where(
              (element) =>
          element.rhFactor == selectedRhFactor
      )
          .toList();
      return filteredBloodDonorList;
    } else{
      filteredBloodDonorList = bloodDonorList;
      return filteredBloodDonorList;
    }
  }

  Future<List<BloodDonorModel>> getBloodDonorList() async {
    print('Initiated:${GlobalVar.basePath}');
    FirebaseDatabase database = FirebaseDatabase.instance;

    //database.ref("${AppConstant.manPowerGroupPath}/${groupNameController.text}/people0");
    DatabaseReference ref = database
        .ref("${GlobalVar.basePath}/${AppConstant.bloodDonorGroupPath}/");
    //print(ref.);
    bloodDonorList.clear();
    await ref.once().then((event) {
      if (event.snapshot.exists) {
        // Extract the data as a Map
        Map<dynamic, dynamic> groupData =
            event.snapshot.value as Map<dynamic, dynamic>;
        for (var key in groupData.keys) {
          String nextTime = '';
          if(groupData[key]
          [AppConstant.lastDateOfBloodDonationColumnText]
              .toString().isNotEmpty){
            nextTime = GlobalVar.nextDateToDonateBlood(groupData[key]
            [AppConstant.lastDateOfBloodDonationColumnText]
                .toString());
          }
          print(
              '$key and the name is ${GlobalVar.customNameDecoder(key).toString()}');
          print(
              '$key and the dob is ${groupData[key][AppConstant.dateOfBirthColumnText].toString()}');
          print(
              '$key and the last date is ${groupData[key][AppConstant.lastDateOfBloodDonationColumnText].toString()}');
          print('$key and the next date is $nextTime');
          print(
              '$key and the blood group with rh is ${groupData[key][AppConstant.bloodGroupColumnText].toString()}');
          print(
              '$key is able to donate blood is ${groupData[key][AppConstant.bloodGroupColumnText].toString()}');
          setState(() {
            bloodDonorList.add(BloodDonorModel(
                key: key.toString(),
                name: GlobalVar.customNameDecoder(key).toString(),
                rhFactor:
                    groupData[key][AppConstant.rhFactorColumnText].toString(),
                bloodGroup:
                    groupData[key][AppConstant.bloodGroupColumnText].toString(),
                dateOfBirth: groupData[key][AppConstant.dateOfBirthColumnText]
                    .toString(),
                nextDateOfBloodDonated: nextTime,
                address: groupData[key][AppConstant.addressColumnText].toString(),
                phoneNumber:
                    groupData[key][AppConstant.mobileColumnText].toString(),
                photoUrl: groupData[key][AppConstant.profileImageColumnText]
                    .toString(),
                lastDateOfBloodDonated: groupData[key]
                        [AppConstant.lastDateOfBloodDonationColumnText]
                    .toString(),
                isAbleToDonateBlood: GlobalVar.bloodDonorStatus(groupData[key]
                        [AppConstant.lastDateOfBloodDonationColumnText]
                    .toString())));
          });
        }
      } else {
        print("No Data exist.");
      }
    });
    bloodDonorList.sort(
      (a, b) => a.name.compareTo(b.name),
    );
    setState(() {
      getFilteredBloodDonorList();
      showLoading = true;
    });
    return bloodDonorList;
  }

  @override
  void initState() {
    if (loadData) {
      donorList =
          getBloodDonorList();
    }
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return BasicAquaHazeBGUi(
        appBarTitle: AppConstant.searchBloodDonorPlainText,
        child: SingleChildScrollView(child: initBuildUi()));
  }

  Widget initBuildUi() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            initBloodDonorFilter(),
            SizedBox(
              height: 10,
            ),
            initBloodDonorList(),
          ],
        ));
  }

  Widget initBloodDonorFilter() {
    return Column(
      children: [initBloodDonorDropDownFilter(), initBloodDonorSearchFilter()],
    );
  }

  Widget initBloodDonorDropDownFilter() {
    return Row(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: width / divisionFactor,
              child: CustomDropdownButton(
                hintText: AppConstant.bloodGroupPlainText,
                dropdownList: bloodGroupList,
                onChangedAction: (String? newValue) {
                  // Handle dropdown value change
                  setState(() {
                    // filteredBloodGroupWithLocation.add(newValue!);
                    selectedBloodGroup = newValue!;
                    donorList = getFilteredBloodDonorList();
                  });
                },
              ),
            ),
            SizedBox(
              width: width / divisionFactor,
              child: CustomDropdownButton(
                hintText: AppConstant.rhFactorPlainText,
                dropdownList: rhFactorList,
                onChangedAction: (String? newValue) {
                  // Handle dropdown value change
                  setState(() {
                    // filteredBloodGroupWithLocation.add(newValue!);
                    selectedRhFactor = newValue!;
                    getFilteredBloodDonorList();
                  });
                },
              ),
            ),

          ],
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: IconButton(
            onPressed: () {
              setState(() {
                selectedRhFactor = '';
                selectedBloodGroup = '';
                getFilteredBloodDonorList();
              });
            },
            icon: Icon(Icons.refresh),
            style: ButtonStyle(
                //elevation: MaterialStatePropertyAll(10),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
                side:
                    MaterialStatePropertyAll(BorderSide(color: AppColor.grey))),
          ),
        )
      ],
    );
  }

  Widget initBloodDonorSearchFilter() {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              child: TextField(
                keyboardType: TextInputType.text,
                onTap: () {},
                // onChanged: ,
                onChanged: (value) {
                  print(value);
                  setState(() {
                    if (value.length > 2) {
                      showSuggestion = true;
                    } else {
                      showSuggestion = false;
                    }
                  });
                },

                controller: searchController,
                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    isDense: true,
                    contentPadding: EdgeInsets.all(10),
                    hintText: AppConstant.searchPlainText,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.grey),
                        borderRadius: BorderRadius.circular(5))),
              ),
            ),
          ],
        ),
        Visibility(
            visible: showSuggestion,
            child: FutureBuilder<List<BloodDonorModel>>(
              future: getSearchedBloodDonorList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('No result Found yet'),
                  );
                }  else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return BloodDonorInformationTab(
                        deleteFunction: () {},
                        editFunction: () {},
                        photo: snapshot.data![index].photoUrl,
                        isEligible:
                        snapshot.data![index].isAbleToDonateBlood,
                        donorName: snapshot.data![index].name,
                        bloodGroupWithRh:
                        snapshot.data![index].bloodGroup +
                            snapshot.data![index].rhFactor,
                      );
                    },
                  );
                }
              },
            ))
      ],
    );
  }

  Widget initBloodDonorList() {
    return TitleIconButtonWithWhiteBackground(
        headline:
            'মোট রক্তদাতা ${GlobalVar.englishNumberToBengali(filteredBloodDonorList.length.toString())} জন',
        actionIcon: Icons.add,
        action: () async {
          loadData = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddBloodDonorScreen()));
          if (loadData) {
            donorList = getBloodDonorList();
          }
        },
        whatToShow: FutureBuilder<List<BloodDonorModel>>(
            future: getFilteredBloodDonorList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting || !showLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                //return Text('Error: ${snapshot.error}');
                return Center(child: Text('Check Internet Connection'));
              } else if (snapshot.data!.isEmpty) {
                return Center(
                  child: Text('Please add Blood donor.'),
                );
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    int digit = index+1;
                    return BloodDonorInformationTab(
                      photo: snapshot.data![index].photoUrl,
                      donorName: '${GlobalVar.englishNumberToBengali(digit.toString())}.${snapshot.data![index].name}',
                      bloodGroupWithRh:
                          '${snapshot.data![index].bloodGroup}${snapshot.data![index].rhFactor}',
                      isEligible:
                      snapshot.data![index].isAbleToDonateBlood,
                      editFunction: () {
                        // print('Edit Pressed');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddBloodDonorScreen(
                                      editDonorInfo:
                                      snapshot.data![index],
                                    )));
                      },
                      deleteFunction: ()  {
                        showDialog(context: context, builder: (context)=>AlertDialog(
                          content: Text('Are you really want to delete the person?'),
                          actions: [
                            TextButton(onPressed: (){
                              Navigator.of(context,rootNavigator: true).pop();
                            }, child: Text('No')),
                            TextButton(onPressed: ()async{
                              showDialog(
                                  context: context,
                                  builder: (context) => Center(
                                    child: CircularProgressIndicator(),
                                  ));
                              if (filteredBloodDonorList[index].photoUrl.isNotEmpty) {
                                final desertRef = FirebaseStorage.instance.ref().child(
                                    "${GlobalVar.basePath}/${AppConstant.bloodDonorGroupPath}/${snapshot.data![index].key}/${AppConstant.userImageName}");

                                await desertRef.delete();
                              }
                              DatabaseReference ref = FirebaseDatabase.instance.ref(
                                  "${GlobalVar.basePath}/${AppConstant.bloodDonorGroupPath}/${snapshot.data![index].key}");

                              await ref.remove();
                              setState(() {
                                snapshot.data!.removeAt(index);
                              });
                              Navigator.of(context, rootNavigator: true).pop();
                              Navigator.of(context, rootNavigator: true).pop();
                            }, child: Text('Yes')),
                          ],
                        ));
                      },
                    );
                  },
                );
              }
            }));
  }
}
