import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smf/utils/extension/theme.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../utils/values/app_constant.dart';
import '../../../../utils/color/app_color.dart';

class AddBusinessScreen extends StatefulWidget {
  const AddBusinessScreen({super.key});

  @override
  State<AddBusinessScreen> createState() => _AddBusinessScreenState();
}

class _AddBusinessScreenState extends State<AddBusinessScreen> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController ownershipController = TextEditingController();

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
    companyNameController.dispose();
    addressController.dispose();
    ownershipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.aquaHaze,
      appBar: CustomAppBar(title: AppConstant.createNewEntryPlainText,),
      body: initBuildUi(),
    );
  }

  Widget initBuildUi(){
    return Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomTextFormField(hint: AppConstant.companyNamePlainText,controller: companyNameController),
                  SizedBox(height: 10,),
                  CustomTextFormField(hint: AppConstant.addressPlainText,controller: addressController),
                  SizedBox(height: 10,),
                  CustomTextFormField(hint: AppConstant.ownershipPlainText,controller: ownershipController),
                  SizedBox(height: 10,),
                  _imagePath == null ? InkWell(
                    onTap: _pickImage,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColor.grey),
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppConstant.logoPlainText),
                          Icon(Icons.file_upload,color: AppColor.grey,)
                        ],
                      ),
                    ),
                  ):SizedBox(
                      height: 350,
                      child: Image.file(File(_imagePath!))),

                ],
              ),
              CustomButton(
                  content: AppConstant.saveEntryPlainText,
                  contentColor: AppColor.white,
                  backgroundColor: AppColor.killarney,
                  onPressed: (){})
            ],
          ),
        ));
  }
}
