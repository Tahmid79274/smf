import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smf/models/group_member_model.dart';
import '../../../../utils/extension/theme.dart';
import '../../../../utils/functionalities/functions.dart';
import '../../../../utils/values/app_constant.dart';
import '../../../../utils/color/app_color.dart';
import 'man_power_list_screen.dart';

class AddManpowerScreen extends StatefulWidget {
  AddManpowerScreen({super.key, required this.groupName, this.editGroupMember});
  String groupName;
  GroupMemberModel? editGroupMember;

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
  void initState() {
    if (widget.editGroupMember != null) {
      nameController.text = widget.editGroupMember!.name;
      mobileNumberController.text = widget.editGroupMember!.mobileNumber;
      cityNameController.text = widget.editGroupMember!.cityName;
      districtNameController.text = widget.editGroupMember!.districtName;
      postCodeController.text = widget.editGroupMember!.postCode;
      divisionController.text = widget.editGroupMember!.division;
      imageUrl = widget.editGroupMember!.photoUrl;
    }
    super.initState();
  }

  @override
  void dispose() {
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
    return BasicAquaHazeBGUi(
        appBarTitle: AppConstant.addManpowerPlainText, child: initBuildUi());
  }

  Widget initBuildUi() {
    return Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ListView(
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              // mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
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
                const SizedBox(
                  height: 10,
                ),
                CustomTextFormField(
                  hint: AppConstant.namePlainText,
                  controller: nameController,
                  keyboardInputType: TextInputType.text,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextFormField(
                  hint: AppConstant.mobileNumberPlainText,
                  controller: mobileNumberController,
                  keyboardInputType: TextInputType.phone,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextFormField(
                    hint: AppConstant.cityNamePlainText,
                    controller: cityNameController,
                    keyboardInputType: TextInputType.text),
                SizedBox(
                  height: 10,
                ),
                CustomTextFormField(
                    hint: AppConstant.districtNamePlainText,
                    controller: districtNameController,
                    keyboardInputType: TextInputType.text),
                SizedBox(
                  height: 10,
                ),
                CustomTextFormField(
                    hint: AppConstant.postCodePlainText,
                    controller: postCodeController,
                    keyboardInputType: TextInputType.number),
                SizedBox(
                  height: 10,
                ),
                CustomTextFormField(
                    hint: AppConstant.divisionPlainText,
                    controller: divisionController,
                    keyboardInputType: TextInputType.text),
              ],
            ),
            CustomButton(
                content: widget.editGroupMember == null
                    ? AppConstant.addPlainText
                    : AppConstant.changePlainText,
                contentColor: AppColor.white,
                backgroundColor: AppColor.killarney,
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    String downloadUrl = '';
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        });
                    if (widget.editGroupMember == null) {
                      String uniqueName =
                          GlobalVar.customNameEncoder(nameController.text);
                      final storageRef = FirebaseStorage.instance.ref();
                      if (_imagePath.isNotEmpty) {
                        File file = File(_imagePath);
                        final metadata =
                            SettableMetadata(contentType: "image/jpeg");
                        print('Image Path: $_imagePath');
                        print('File Path: ${file.path}');
                        final uploadTask = storageRef
                            .child(
                                "${AppConstant.manPowerGroupPath}/${widget.groupName}/$uniqueName/${AppConstant.userImageName}")
                            .putFile(file, metadata);
                        print(
                            'Image Upload Time:${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}');
                        uploadTask.snapshotEvents
                            .listen((TaskSnapshot taskSnapshot) async {
                          switch (taskSnapshot.state) {
                            case TaskState.running:
                              final progress = 100.0 *
                                  (taskSnapshot.bytesTransferred /
                                      taskSnapshot.totalBytes);
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
                              print(
                                  'Time to get url:${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}');
                              downloadUrl =
                                  await taskSnapshot.ref.getDownloadURL();
                              print('Successfull');
                              print('download url:$downloadUrl');
                              print(
                                  'Download url Current time:${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}');
                              break;
                          }
                        });
                      }
                      await Future.delayed(const Duration(seconds: 7))
                          .whenComplete(() async {
                        FirebaseDatabase database = FirebaseDatabase.instance;

                        DatabaseReference ref = database.ref(
                            "${AppConstant.manPowerGroupPath}/${widget.groupName}/$uniqueName");

                        await ref.set({
                          AppConstant.nameColumnText: nameController.text,
                          AppConstant.mobileColumnText:
                              mobileNumberController.text,
                          AppConstant.cityNameColumnText:
                              cityNameController.text,
                          AppConstant.districtNameColumnText:
                              districtNameController.text,
                          AppConstant.postCodeColumnText:
                              postCodeController.text,
                          AppConstant.divisionColumnText:
                              divisionController.text,
                          AppConstant.profileImageColumnText: downloadUrl,
                        });
                      });
                      //_groupsFuture = getGroupList();
                      print('');
                    } else {
                      DatabaseReference ref = FirebaseDatabase.instance.ref("${AppConstant.manPowerGroupPath}/${widget.groupName}/${widget.editGroupMember!.key}");
                      ref.update({
                        AppConstant.nameColumnText: nameController.text,
                        AppConstant.mobileColumnText: mobileNumberController.text,
                        AppConstant.cityNameColumnText: cityNameController.text,
                        AppConstant.districtNameColumnText: districtNameController.text,
                        AppConstant.postCodeColumnText: postCodeController.text,
                        AppConstant.divisionColumnText: divisionController.text,
                      });
                    }
                    Navigator.of(context, rootNavigator: true).pop();
                    Navigator.of(context, rootNavigator: true)
                        .pushReplacement(MaterialPageRoute(
                        builder: (context) =>
                            ManPowerGroupListScreen(selectedGroup: widget.groupName,)));
                  }
                })
          ],
        ));
  }
}
