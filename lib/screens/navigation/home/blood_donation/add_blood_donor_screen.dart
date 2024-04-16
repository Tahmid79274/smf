import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smf/utils/extension/theme.dart';
import 'package:smf/utils/values/app_constant.dart';

import '../../../../utils/color/app_color.dart';

class AddBloodDonorScreen extends StatefulWidget {
  const AddBloodDonorScreen({super.key});

  @override
  State<AddBloodDonorScreen> createState() => _AddBloodDonorScreenState();
}

class _AddBloodDonorScreenState extends State<AddBloodDonorScreen> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController bloodGroupController = TextEditingController();
  TextEditingController rhController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cityNameController = TextEditingController();
  TextEditingController districtNameController = TextEditingController();
  TextEditingController postController = TextEditingController();
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
    dateOfBirthController.dispose();
    bloodGroupController.dispose();
    rhController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    cityNameController.dispose();
    districtNameController.dispose();
    postController.dispose();
    divisionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasicAquaHazeBGUi(
        appBarTitle: AppConstant.addBloodDonorPlainText, child: SingleChildScrollView(child: initBuildUi()));
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
                CustomTextFormField(hint: AppConstant.dateOfBirthPlainText,controller: dateOfBirthController,onTap: (){


                  setState(() {

                  });
                },),
                SizedBox(height: 10,),
                CustomTextFormField(hint: AppConstant.bloodGroupPlainText,controller: bloodGroupController),
                SizedBox(height: 10,),
                CustomTextFormField(hint: AppConstant.rhPlainText,controller: rhController),
                SizedBox(height: 10,),
                CustomTextFormField(hint: AppConstant.phoneNumberPlainText,controller: phoneNumberController),
                SizedBox(height: 10,),
                CustomTextFormField(hint: AppConstant.emailPlainText,controller: emailController),
                SizedBox(height: 10,),
                GridView(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,),
                  children: [
                    CustomTextFormField(hint: AppConstant.cityNamePlainText,controller: cityNameController),
                    CustomTextFormField(hint: AppConstant.districtNamePlainText,controller: districtNameController),
                    CustomTextFormField(hint: AppConstant.postCodePlainText,controller: postController),
                    CustomTextFormField(hint: AppConstant.divisionPlainText,controller: divisionController),
                  ],
                ),
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
