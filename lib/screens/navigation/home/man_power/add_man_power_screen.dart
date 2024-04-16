

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smf/utils/extension/theme.dart';
import 'package:smf/utils/values/app_constant.dart';

import '../../../../utils/color/app_color.dart';

class AddManpowerScreen extends StatefulWidget {
  const AddManpowerScreen({super.key});

  @override
  State<AddManpowerScreen> createState() => _AddManpowerScreenState();
}

class _AddManpowerScreenState extends State<AddManpowerScreen> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController cityNameController = TextEditingController();
  TextEditingController districtNameController = TextEditingController();
  TextEditingController postCodeController = TextEditingController();
  TextEditingController divisionController = TextEditingController();

  String? _imagePath;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imagePath = pickedImage.path;
      });
    }
  }

  @override
  void dispose(){
    nameController.dispose();
    mobileNumberController.dispose();
    cityNameController.dispose();
    districtNameController.dispose();
    postCodeController.dispose();
    divisionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasicAquaHazeBGUi(appBarTitle: AppConstant.addManpowerPlainText, child: initBuildUi());
  }

  Widget initBuildUi(){
    return Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                _imagePath == null ? InkWell(
                  onTap: _pickImage,
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(bottom: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.file_upload,color: AppColor.grey,),
                        SizedBox(height: 10),
                        Text(AppConstant.addPicturePlainText),
                      ],
                    ),
                  ),
                ):SizedBox(
                    height: 350,
                    child: Image.file(File(_imagePath!))),
                const SizedBox(height: 10,),
                CustomTextFormField(hint: AppConstant.namePlainText,controller: nameController),
                SizedBox(height: 10,),
                CustomTextFormField(hint: AppConstant.mobileNumberPlainText,controller: mobileNumberController),
                SizedBox(height: 10,),
                CustomTextFormField(hint: AppConstant.cityNamePlainText,controller: cityNameController),
                SizedBox(height: 10,),
                CustomTextFormField(hint: AppConstant.districtNamePlainText,controller: districtNameController),
                SizedBox(height: 10,),
                CustomTextFormField(hint: AppConstant.postCodePlainText,controller: postCodeController),
                SizedBox(height: 10,),
                CustomTextFormField(hint: AppConstant.divisionPlainText,controller: divisionController),
              ],
            ),
            CustomButton(
                content: AppConstant.addPlainText,
                contentColor: AppColor.white,
                backgroundColor: AppColor.killarney,
                onPressed: (){})
          ],
        ));
  }

}
