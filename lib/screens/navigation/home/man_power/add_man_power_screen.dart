

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smf/utils/extension/theme.dart';
import 'package:smf/utils/functionalities/functions.dart';
import 'package:smf/utils/values/app_constant.dart';

import '../../../../utils/color/app_color.dart';

class AddManpowerScreen extends StatefulWidget {
  AddManpowerScreen({super.key,required this.groupName});
  String groupName;

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
  void initState(){
    super.initState();
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
                ):Container(
                  alignment: Alignment.center,
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: FileImage(File(_imagePath!)),
                      fit: BoxFit.fill,
                      alignment: Alignment.center,
                    ),
                  ),
                  // Set a width and height if needed (optional)
                ),
                /*Container(
                  alignment: Alignment.center,
                  width: 100,
                  height: 100,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle
                    ),
                    child: Image.file(File(_imagePath!),alignment: Alignment.center,fit: BoxFit.contain,)),*/
                const SizedBox(height: 10,),
                CustomTextFormField(hint: AppConstant.namePlainText,controller: nameController,keyboardInputType: TextInputType.text,),
                SizedBox(height: 10,),
                CustomTextFormField(hint: AppConstant.mobileNumberPlainText,controller: mobileNumberController,keyboardInputType: TextInputType.phone,),
                SizedBox(height: 10,),
                CustomTextFormField(hint: AppConstant.cityNamePlainText,controller: cityNameController,keyboardInputType: TextInputType.text),
                SizedBox(height: 10,),
                CustomTextFormField(hint: AppConstant.districtNamePlainText,controller: districtNameController,keyboardInputType: TextInputType.text),
                SizedBox(height: 10,),
                CustomTextFormField(hint: AppConstant.postCodePlainText,controller: postCodeController,keyboardInputType: TextInputType.number),
                SizedBox(height: 10,),
                CustomTextFormField(hint: AppConstant.divisionPlainText,controller: divisionController,keyboardInputType: TextInputType.text),
              ],
            ),
            CustomButton(
                content: AppConstant.addPlainText,
                contentColor: AppColor.white,
                backgroundColor: AppColor.killarney,
                onPressed: ()async{
                  String newPeople = GlobalVar.customNameEncoder(nameController.text);
                  print('New People:$newPeople');
                  /*FirebaseDatabase database = FirebaseDatabase.instance;
                  final firebaseApp = Firebase.app();
                  final rtdb = FirebaseDatabase.instanceFor(
                      app: firebaseApp,
                      databaseURL:
                      'https://smfmobileapp-5b74e-default-rtdb.firebaseio.com/');

                  DatabaseReference ref = database.ref(
                      "${AppConstant.manPowerGroupPath}/${widget.groupName}/$newPeople");

                  await ref.set({
                    AppConstant.nameColumnText: nameController.text,
                    AppConstant.mobileColumnText: mobileNumberController.text,
                    AppConstant.cityNameColumnText: cityNameController.text,
                    AppConstant.districtNameColumnText: districtNameController.text,
                    AppConstant.postCodeColumnText: postCodeController.text,
                    AppConstant.divisionColumnText: divisionController.text,
                    AppConstant.profileImageColumnText: _imagePath,
                  });
                  Navigator.pop(context);
                  //_groupsFuture = getGroupList();
                  print('');*/
                })
          ],
        ));
  }

}
