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
  int totalDonor = 0;
  List<String> bloodGroupList = [
    'A',
    'AB',
    'B',
    '0',
  ];
  String selectedBloodGroup = '';
  List<String> rhFactorList = ['+', '-'];
  String selectedRhFactor = '';
  List<String> locationList = [];
  String selectedLocationList = '';

  double height = 0;
  double width = 0;

  List<BloodDonorModel> bloodDonorList = [];
  Map<String, String> groupMap = {};

  Future<List<BloodDonorModel>>? donorList;

  Future<List<BloodDonorModel>> getBloodDonorList() async {
    print('Initiated');
    FirebaseDatabase database = FirebaseDatabase.instance;

    //database.ref("${AppConstant.manPowerGroupPath}/${groupNameController.text}/people0");
    DatabaseReference ref = database.ref("${GlobalVar.basePath}/${AppConstant.bloodDonorGroupPath}/");
    //print(ref.);
    bloodDonorList.clear();
    await ref.once().then((event) {
      if (event.snapshot.exists) {
        // Extract the data as a Map
        Map<dynamic, dynamic> groupData =
            event.snapshot.value as Map<dynamic, dynamic>;
        for (var key in groupData.keys) {
          String nextTime = GlobalVar.nextDateToDonateBlood(groupData[key]
                  [AppConstant.lastDateOfBloodDonationColumnText]
              .toString());
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
                email: groupData[key][AppConstant.emailColumnText].toString(),
                phoneNumber:
                    groupData[key][AppConstant.mobileColumnText].toString(),
                cityName:
                    groupData[key][AppConstant.cityNameColumnText].toString(),
                divisionName:
                    groupData[key][AppConstant.divisionColumnText].toString(),
                districtName: groupData[key][AppConstant.districtNameColumnText]
                    .toString(),
                postCode:
                    groupData[key][AppConstant.postCodeColumnText].toString(),
                photoUrl: groupData[key][AppConstant.profileImageColumnText]
                    .toString(),
                lastDateOfBloodDonated: groupData[key]
                        [AppConstant.lastDateOfBloodDonationColumnText]
                    .toString(),
                isAbleToDonateBlood: GlobalVar.bloodDonorStatus(groupData[key]
                        [AppConstant.lastDateOfBloodDonationColumnText]
                    .toString())));
            locationList.add(bloodDonorList.last.cityName);
            totalDonor = bloodDonorList.length;
          });
        }
      } else {
        print("No Data exist.");
      }
    });
    bloodDonorList.sort((a, b) => a.name.compareTo(b.name),);
    return bloodDonorList;
  }

  @override
  void initState() {
    if (loadData) {
      donorList = getBloodDonorList();
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
      ),
    );
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
              width: width / 4,
              child: CustomDropdownButton(
                hintText: AppConstant.bloodGroupPlainText,
                dropdownList: bloodGroupList,
                onChangedAction: (String? newValue) {
                  // Handle dropdown value change
                  setState(() {
                    selectedBloodGroup = newValue!;
                  });
                },
              ),
            ),
            SizedBox(
              width: width / 4,
              child: CustomDropdownButton(
                hintText: AppConstant.rhFactorPlainText,
                dropdownList: rhFactorList,
                onChangedAction: (String? newValue) {
                  // Handle dropdown value change
                  setState(() {
                    selectedRhFactor = newValue!;
                  });
                },
              ),
            ),
            SizedBox(
              width: width / 4,
              child: CustomDropdownButton(
                hintText: AppConstant.locationPlainText,
                dropdownList: locationList,
                onChangedAction: (String? newValue) {
                  // Handle dropdown value change
                  setState(() {
                    selectedLocationList = newValue!;
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
            onPressed: () {},
            icon: Icon(Icons.arrow_forward_ios),
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
    return Row(
      children: [
        Flexible(
          child: CustomTextFormField(
            // isMandatory: false,
            hint: AppConstant.searchPlainText,
            keyboardInputType: TextInputType.text,
            controller: searchController,
            suffixIcon: Icons.search,
          ),
        ),
        // SizedBox(
        //   width: 10,
        // ),
        // IconButton(
        //   onPressed: () {},
        //   icon: Icon(Icons.add),
        //   style: ButtonStyle(
        //       //elevation: MaterialStatePropertyAll(10),
        //       shape: MaterialStateProperty.all(RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(5))),
        //       side: MaterialStatePropertyAll(BorderSide(color: AppColor.grey))),
        // )
      ],
    );
  }

  Widget initBloodDonorList() {
    return TitleIconButtonWithWhiteBackground(
        headline:
            'মোট রক্তদাতা ${GlobalVar.englishNumberToBengali(totalDonor.toString())} জন',
        actionIcon: Icons.add,
        action: () async {
          loadData = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddBloodDonorScreen()));
          if (loadData) {
            donorList = getBloodDonorList();
          }
        },
        whatToShow: FutureBuilder<List<BloodDonorModel>>(
          future: donorList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
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
                  return BloodDonorInformationTab(
                    photo: snapshot.data![index].photoUrl,
                    donorName: snapshot.data![index].name,
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
                    deleteFunction: () async {
                      showDialog(
                          context: context,
                          builder: (context) => Center(
                                child: CircularProgressIndicator(),
                              ));
                      if(snapshot.data![index].photoUrl.isNotEmpty){
                        final desertRef = FirebaseStorage.instance.ref().child(
                            "${AppConstant.bloodDonorGroupPath}/${snapshot.data![index].key}/${AppConstant.userImageName}");

                        await desertRef.delete();
                      }
                      DatabaseReference ref = FirebaseDatabase.instance.ref(
                          "${AppConstant.bloodDonorGroupPath}/${snapshot.data![index].key}");

                      await ref.remove();
                      setState(() {
                        snapshot.data!.removeAt(index);
                        totalDonor = snapshot.data!.length;
                      });
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  );
                },
              );
            }
          },
        ));
  }
}
