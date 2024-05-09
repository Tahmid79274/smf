import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:smf/utils/extension/theme.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../utils/values/app_constant.dart';
import '../../../../models/account_model.dart';
import '../../../../utils/color/app_color.dart';
import '../../../../utils/functionalities/functions.dart';
import './account_screen.dart';

class AddBusinessScreen extends StatefulWidget {
  AddBusinessScreen({super.key,this.editCompanyInfo});
  AccountModel? editCompanyInfo;

  @override
  State<AddBusinessScreen> createState() => _AddBusinessScreenState();
}

class _AddBusinessScreenState extends State<AddBusinessScreen> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController ownershipController = TextEditingController();

  String _imagePath = '';
  String imageUrl = '';


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
    if(widget.editCompanyInfo!=null){
      companyNameController.text = widget.editCompanyInfo!.companyName;
      addressController.text = widget.editCompanyInfo!.address;
      ownershipController.text = widget.editCompanyInfo!.ownershipName;
      imageUrl = widget.editCompanyInfo!.imageUrl;
    }
    super.initState();
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
                  CustomTextFormField(isMandatory: true,hint: AppConstant.companyNamePlainText,controller: companyNameController,keyboardInputType: TextInputType.text),
                  SizedBox(height: 10,),
                  CustomTextFormField(isMandatory: false,hint: AppConstant.addressPlainText,controller: addressController,keyboardInputType: TextInputType.text),
                  SizedBox(height: 10,),
                  CustomTextFormField(isMandatory: true,hint: AppConstant.ownershipPlainText,controller: ownershipController,keyboardInputType: TextInputType.text),
                  SizedBox(height: 10,),
                  imageUrl.isNotEmpty
                      ? Container(
                      width: 100,
                      height: 100,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(
                                imageUrl,
                              ),
                              fit: BoxFit.fill)))
                      : _imagePath.isEmpty
                      ? InkWell(
                    onTap: _pickImage,
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.file_upload,
                            color: AppColor.grey,
                          ),
                          SizedBox(height: 10),
                          Text(AppConstant.addPicturePlainText),
                        ],
                      ),
                    ),
                  )
                      : Container(
                    alignment: Alignment.center,
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: FileImage(File(_imagePath)),
                        fit: BoxFit.fill,
                        alignment: Alignment.center,
                      ),
                    ),
                    // Set a width and height if needed (optional)
                  ),

                ],
              ),
              CustomButton(
                  content: AppConstant.saveEntryPlainText,
                  contentColor: AppColor.white,
                  backgroundColor: AppColor.killarney,
                  onPressed: ()async{
                    if(formKey.currentState!.validate()){
                      if(widget.editCompanyInfo==null){
                        String downloadUrl = '';
                        showDialog(context: context, builder: (context){
                          return Center(child: CircularProgressIndicator(),);
                        });
                        String uniqueName = GlobalVar.customNameEncoder(companyNameController.text);
                        final storageRef = FirebaseStorage.instance.ref();
                        if(_imagePath.isNotEmpty){
                          File file = File(_imagePath);
                          final metadata = SettableMetadata(contentType: "image/jpeg");
                          print('Image Path: $_imagePath');
                          print('File Path: ${file.path}');
                          final uploadTask = storageRef.child("${AppConstant.accountPath}/$uniqueName/${AppConstant.userImageName}").putFile(file,metadata);
                          print('Image Upload Time:${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}');
                          uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
                            switch (taskSnapshot.state) {
                              case TaskState.running:
                                final progress =
                                    100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
                                print("Upload is $progress% complete.");
                                break;
                              case TaskState.paused:
                                print("Upload is paused.");
                                break;
                              case TaskState.canceled:
                                print("Upload was canceled");
                                break;
                              case TaskState.error:
                              // Handle unsuccessful uploads
                                print('Error occured');
                                break;
                              case TaskState.success:
                              // Handle successful uploads on complete
                              // ...
                                print('Time to get url:${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}');
                                downloadUrl = await taskSnapshot.ref.getDownloadURL();
                                print('Successfull');
                                print('download url:$downloadUrl');
                                print('Download url Current time:${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}');
                                break;
                            }
                          });
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: AppColor.red,
                              content: Text('Please add image')));
                        }
                        await Future.delayed(Duration(seconds: _imagePath.isNotEmpty ? 7 : 0)).whenComplete(() async{
                          print('Upload Current time:${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}');
                          FirebaseDatabase database = FirebaseDatabase.instance;

                          DatabaseReference ref = database.ref(
                              "${AppConstant.accountPath}/${uniqueName}");

                          await ref.set({
                            AppConstant.companyNameColumnText: companyNameController.text,
                            AppConstant.addressColumnText: addressController.text,
                            AppConstant.ownershipColumnText: ownershipController.text,
                            AppConstant.businessLogoColumnText: downloadUrl,
                            AppConstant.transactionsColumnText: '',
                          });
                        });
                      }
                      else{
                        DatabaseReference ref = FirebaseDatabase.instance.ref("${AppConstant.accountPath}/${widget.editCompanyInfo!.key}");
                        ref.update({
                          AppConstant.companyNameColumnText: companyNameController.text,
                          AppConstant.addressColumnText: addressController.text,
                          AppConstant.ownershipColumnText: ownershipController.text,
                        });
                      }
                      Navigator.of(context,rootNavigator: true).pop();
                      Navigator.pop(context, true);
                    }
                  })
            ],
          ),
        ));
  }
}
