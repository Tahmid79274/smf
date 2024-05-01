import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smf/utils/extension/theme.dart';
import '../../../../utils/color/app_color.dart';
import '../../../../utils/values/app_constant.dart';
import 'add_blood_donor_screen.dart';

class BloodDonorDirectoryScreen extends StatefulWidget {
  const BloodDonorDirectoryScreen({super.key});

  @override
  State<BloodDonorDirectoryScreen> createState() =>
      _BloodDonorDirectoryScreenState();
}

class _BloodDonorDirectoryScreenState extends State<BloodDonorDirectoryScreen> {
  TextEditingController searchController = TextEditingController();

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
          SizedBox(height: 10,),
          initBloodDonorList(),
        ],
      ),
    );
  }

  Widget initBloodDonorFilter() {
    return Column(
      children: [
        initBloodDonorDropDownFilter(),
        initBloodDonorSearchFilter()
      ],
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
                hintText: AppConstant.rhPlainText,
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
        Expanded(
          child: CustomTextFormField(
            hint: AppConstant.searchPlainText,
            keyboardInputType: TextInputType.text,
            controller: searchController,
            suffixIcon: Icons.search,
          ),
        ),
        SizedBox(width: 10,),
        IconButton(onPressed: (){}, icon: Icon(Icons.add),style: ButtonStyle(
          //elevation: MaterialStatePropertyAll(10),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
            side: MaterialStatePropertyAll(BorderSide(color: AppColor.grey))
        ),)
      ],
    );
  }

  Widget initBloodDonorList() {
    return TitleIconButtonWithWhiteBackground(
      headline: 'মোট রক্তদাতা ১৫৬ জন',
      actionIcon: Icons.add,
      action: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => AddBloodDonorScreen()));
      },
      whatToShow: ListView(
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          BloodDonorInformationTab(
            bloodGroupWithRh: 'A+',
            donorName: 'Shraban Ahmed',
            isEligible: true,
          ),
          BloodDonorInformationTab(
            bloodGroupWithRh: 'A+',
            donorName: 'Shraban Ahmed',
            isEligible: true,
          ),
          BloodDonorInformationTab(
            bloodGroupWithRh: 'A+',
            donorName: 'Shraban Ahmed',
            isEligible: true,
          ),
          BloodDonorInformationTab(
            bloodGroupWithRh: 'A+',
            donorName: 'Shraban Ahmed',
            isEligible: true,
          ),
          BloodDonorInformationTab(
            bloodGroupWithRh: 'A+',
            donorName: 'Shraban Ahmed',
            isEligible: true,
          ),
          BloodDonorInformationTab(
            bloodGroupWithRh: 'A+',
            donorName: 'Shraban Ahmed',
            isEligible: true,
          ),
          BloodDonorInformationTab(
            bloodGroupWithRh: 'A+',
            donorName: 'Shraban Ahmed',
            isEligible: true,
          ),
          BloodDonorInformationTab(
            bloodGroupWithRh: 'A+',
            donorName: 'Shraban Ahmed',
            isEligible: true,
          ),
          BloodDonorInformationTab(
            bloodGroupWithRh: 'A+',
            donorName: 'Shraban Ahmed',
            isEligible: true,
          ),
        ],
      ),
    );
  }
}
