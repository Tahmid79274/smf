import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smf/utils/extension/theme.dart';
import 'package:smf/utils/values/app_constant.dart';

import '../../../../utils/color/app_color.dart';
import '../../../../utils/functionalities/functions.dart';

class AddBloodDonorScreen extends StatefulWidget {
  const AddBloodDonorScreen({super.key});

  @override
  State<AddBloodDonorScreen> createState() => _AddBloodDonorScreenState();
}

class _AddBloodDonorScreenState extends State<AddBloodDonorScreen> {

  String today = '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';
  late DateTime lastDateOfBloodDonated ;
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
  TextEditingController lastDateOfBloodDonationController = TextEditingController();
  TextEditingController abilityToDonateBloodController = TextEditingController();
  TextEditingController nextDateToAbleToDonateBloodController = TextEditingController();

  String? _imagePath;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imagePath = pickedImage.path;
        // _imageFile = File(_imagePath!);
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
    lastDateOfBloodDonationController.dispose();
    abilityToDonateBloodController.dispose();
    nextDateToAbleToDonateBloodController.dispose();
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
                const SizedBox(height: 10,),
                CustomTextFormField(hint: AppConstant.namePlainText,controller: nameController,keyboardInputType: TextInputType.text),
                SizedBox(height: 10,),
                CustomTextFormField(hint: AppConstant.dateOfBirthPlainText,controller: dateOfBirthController,
                  keyboardInputType: TextInputType.datetime,
                  onTap: (){
                  showModalBottomSheet(context: context, builder: (context) {
                    return CustomCalendar(today: today,
                    dateChangeFunction: (selectedDate) {
                      setState(() {
                        today = selectedDate==null?'':'${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
                      });
                    },
                      saveFunction: (){
                      Navigator.of(context,rootNavigator: true).pop();
                      setState(() {
                        dateOfBirthController.text = today;
                      });
                      },
                    );
                  },);
                },),
                SizedBox(height: 10,),
                CustomTextFormField(hint: AppConstant.bloodGroupPlainText,controller: bloodGroupController,keyboardInputType: TextInputType.text),
                SizedBox(height: 10,),
                CustomTextFormField(hint: AppConstant.rhPlainText,controller: rhController,keyboardInputType: TextInputType.text),
                SizedBox(height: 10,),
                CustomTextFormField(hint: AppConstant.phoneNumberPlainText,controller: phoneNumberController,keyboardInputType: TextInputType.phone),
                SizedBox(height: 10,),
                CustomTextFormField(hint: AppConstant.emailPlainText,controller: emailController,keyboardInputType: TextInputType.emailAddress),
                SizedBox(height: 10,),
                GridView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 5,childAspectRatio: 5,mainAxisSpacing: 10),
                  children: [
                    CustomTextFormField(hint: AppConstant.cityNamePlainText,controller: cityNameController,keyboardInputType: TextInputType.text),
                    CustomTextFormField(hint: AppConstant.districtNamePlainText,controller: districtNameController,keyboardInputType: TextInputType.text),
                    CustomTextFormField(hint: AppConstant.postCodePlainText,controller: postController,keyboardInputType: TextInputType.number),
                    CustomTextFormField(hint: AppConstant.divisionPlainText,controller: divisionController,keyboardInputType: TextInputType.text),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10,),
            CustomTextFormField(hint: AppConstant.lastDateOfBloodDonationPlainText,controller: lastDateOfBloodDonationController,
                keyboardInputType: TextInputType.datetime,
                onTap: (){
                  showModalBottomSheet(context: context, builder: (context) {
                    return CustomCalendar(today: today,
                      dateChangeFunction: (selectedDate) {
                        setState(() {
                          lastDateOfBloodDonated = selectedDate!;
                        });
                      },
                      saveFunction: (){

                        print('Selected date:$lastDateOfBloodDonated');
                        Navigator.of(context,rootNavigator: true).pop();
                        setState(() {
                          lastDateOfBloodDonationController.text = '${lastDateOfBloodDonated.day}/${lastDateOfBloodDonated.month}/${lastDateOfBloodDonated.year}';
                          nextDateToAbleToDonateBloodController.text = '${lastDateOfBloodDonated.add(Duration(days: 90)).day}/${lastDateOfBloodDonated.add(Duration(days: 90)).month}/${lastDateOfBloodDonated.add(Duration(days: 90)).year}';
                          print('Total Dys:${DateTime.now().difference(lastDateOfBloodDonated)}');
                          if (DateTime.now().difference(lastDateOfBloodDonated).inDays>=90){
                            abilityToDonateBloodController.text = AppConstant.ableToDonateBloodPlainText;
                          }
                          else{
                            abilityToDonateBloodController.text = AppConstant.notAbleToDonateBloodPlainText;
                          }
                        });
                      },
                    );
                  },);
                }
            ),
            SizedBox(height: 10,),
            CustomTextFormField(hint: AppConstant.abilityToDonateBloodPlainText,controller: abilityToDonateBloodController,keyboardInputType: TextInputType.datetime),
            SizedBox(height: 10,),
            CustomTextFormField(hint: AppConstant.nextDateToAbleToDonateBloodPlainText,controller: nextDateToAbleToDonateBloodController,keyboardInputType: TextInputType.datetime),
            SizedBox(height: 10,),
            CustomButton(
                content: AppConstant.addPlainText,
                contentColor: AppColor.white,
                backgroundColor: AppColor.killarney,
                onPressed: ()async{
                  setState(() {
                    if(_imagePath!.isNotEmpty==false){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please add a photo.')));
                    }
                  });
                  if(formKey.currentState!.validate() && _imagePath!.isNotEmpty){
                    String uniqueName = GlobalVar.customNameEncoder(nameController.text);
                    final storageRef = FirebaseStorage.instance.ref();
                    File file = File(_imagePath!);
                    final metadata = SettableMetadata(contentType: "image/jpeg");
                    print('Image Path: $_imagePath');
                    print('File Path: ${file.path}');
                    final uploadTask = storageRef.child('${AppConstant.bloodDonorGroupPath}/$uniqueName').putFile(file,metadata);
                    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
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

                          print('Successfull');
                          break;
                      }
                    });
                  }
                })
          ],
        ));
  }
}
