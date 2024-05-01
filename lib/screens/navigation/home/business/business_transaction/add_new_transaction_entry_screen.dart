import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smf/utils/values/app_constant.dart';

import '../../../../../utils/color/app_color.dart';
import '../../../../../utils/extension/theme.dart';

class AddNewBusinessTransactionEntryScreen extends StatefulWidget {
  const AddNewBusinessTransactionEntryScreen({super.key});

  @override
  State<AddNewBusinessTransactionEntryScreen> createState() => _AddNewBusinessTransactionEntryScreenState();
}

class _AddNewBusinessTransactionEntryScreenState extends State<AddNewBusinessTransactionEntryScreen> {

  String? _imagePath;
  bool isDebit = true;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();
  TextEditingController entryTitleController = TextEditingController();
  TextEditingController entryDetailsController = TextEditingController();
  TextEditingController moneyAmountController = TextEditingController();

  @override
  void dispose(){
    dateController.dispose();
    entryTitleController.dispose();
    entryTitleController.dispose();
    entryDetailsController.dispose();
    moneyAmountController.dispose();
    super.dispose();
  }

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
  Widget build(BuildContext context) {
    return BasicAquaHazeBGUi(
      appBarTitle: AppConstant.addNewEntryPlainText,
      child: initBuildUi(),
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextFormField(hint: AppConstant.datePlainText,controller: dateController,keyboardInputType: TextInputType.datetime),
                  SizedBox(height: 10,),
                  CustomTextFormField(hint: AppConstant.entryTitlePlainText,controller: entryTitleController,keyboardInputType: TextInputType.text),
                  SizedBox(height: 10,),
                  CustomTextFormField(hint: AppConstant.entryDetailsPlainText,controller: entryDetailsController,keyboardInputType: TextInputType.text),
                  SizedBox(height: 10,),
                  CustomTextFormField(hint: AppConstant.moneyAmountPlainText,controller: entryDetailsController,keyboardInputType: TextInputType.numberWithOptions()),
                  SizedBox(height: 10,),
                  initEntryTypeUI(),
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
                          Text(AppConstant.addImagePlainText),
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

  Widget initEntryTypeUI(){
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.grey),
          borderRadius: BorderRadius.circular(5)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(AppConstant.entryTypePlainText),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(onPressed: (){},
                  child: Text('+ ${AppConstant.debitPlainText}',style: TextStyle(fontSize:20,fontWeight: FontWeight.bold,color: AppColor.white),),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(AppColor.killarney),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))
                  )
              ),
              ElevatedButton(onPressed: (){},
                  child: Text('- ${AppConstant.creditPlainText}',style: TextStyle(fontSize:20,fontWeight: FontWeight.bold,color: AppColor.red),),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(AppColor.nebula),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))
                  )
              ),
              // CustomButton(content: AppConstant.creditPlainText, contentColor: AppColor.red, backgroundColor: AppColor.nebula, onPressed: (){}),
            ],
          )
        ],
      ),
    );
  }

}
