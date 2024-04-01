import 'package:flutter/material.dart';
import 'package:smf/utils/extension/theme.dart';

import '../../../utils/color/app_color.dart';
import '../../../utils/values/app_constant.dart';

class BloodDonorDirectoryScreen extends StatefulWidget {
  const BloodDonorDirectoryScreen({super.key});

  @override
  State<BloodDonorDirectoryScreen> createState() => _BloodDonorDirectoryScreenState();
}

class _BloodDonorDirectoryScreenState extends State<BloodDonorDirectoryScreen> {

  List<String> bloodGroupList = ['A+','A-','AB+','AB-','0+','0-',];
  String selectedBloodGroup = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: CustomAppBar(title: AppConstant.searchBloodDonorPlainText),
      body: initBuildUi(),
    );
  }

  Widget initBuildUi(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          initBloodDonorFilter(),
          //initBloodDonorList(),
        ],
      ),
    );
  }

  Widget initBloodDonorFilter(){
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                hint: Text(AppConstant.bloodGroupPlainText),
                isDense: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                //value: selectedBloodGroup, // Set the currently selected value
                items: bloodGroupList.map((String bloodGroup) {
                  return DropdownMenuItem<String>(
                    value: bloodGroup,
                    child: Text(bloodGroup),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  // Handle dropdown value change
                  setState(() {
                    selectedBloodGroup = newValue!;
                  });
                },
              ),
            ),
            Expanded(
              child: DropdownButtonFormField<String>(
                hint: Text(AppConstant.bloodGroupPlainText),
                isDense: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                //value: selectedBloodGroup, // Set the currently selected value
                items: bloodGroupList.map((String bloodGroup) {
                  return DropdownMenuItem<String>(
                    value: bloodGroup,
                    child: Text(bloodGroup),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  // Handle dropdown value change
                  setState(() {
                    selectedBloodGroup = newValue!;
                  });
                },
              ),
            ),
            Expanded(
              child: DropdownButtonFormField<String>(
                hint: Text(AppConstant.bloodGroupPlainText),
                isDense: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                //value: selectedBloodGroup, // Set the currently selected value
                items: bloodGroupList.map((String bloodGroup) {
                  return DropdownMenuItem<String>(
                    value: bloodGroup,
                    child: Text(bloodGroup),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  // Handle dropdown value change
                  setState(() {
                    selectedBloodGroup = newValue!;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget initBloodDonorList(){
    return ListView();
  }
}
