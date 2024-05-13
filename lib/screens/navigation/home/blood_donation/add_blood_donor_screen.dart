import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smf/models/blood_donor_model.dart';
import 'package:smf/utils/extension/theme.dart';
import 'package:smf/utils/values/app_constant.dart';
import '../../../../utils/color/app_color.dart';
import '../../../../utils/functionalities/functions.dart';

class AddBloodDonorScreen extends StatefulWidget {
  AddBloodDonorScreen({super.key, this.editDonorInfo});
  BloodDonorModel? editDonorInfo;

  @override
  State<AddBloodDonorScreen> createState() => _AddBloodDonorScreenState();
}

class _AddBloodDonorScreenState extends State<AddBloodDonorScreen> {
  List<String> bloodGroupList = [
    'A',
    'AB',
    'B',
    'O',
  ];
  String selectedBloodGroup = '';
  List<String> rhFactorList = ['+', '-'];
  String selectedRhFactor = '';

  String today =
      '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';
  late DateTime lastDateOfBloodDonated;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cityNameController = TextEditingController();
  TextEditingController districtNameController = TextEditingController();
  TextEditingController postCodeController = TextEditingController();
  TextEditingController divisionController = TextEditingController();
  TextEditingController lastDateOfBloodDonationController =
      TextEditingController();
  TextEditingController abilityToDonateBloodController =
      TextEditingController();
  TextEditingController nextDateToAbleToDonateBloodController =
      TextEditingController();

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
    if (widget.editDonorInfo != null) {
      nameController.text = widget.editDonorInfo!.name;
      dateOfBirthController.text = widget.editDonorInfo!.dateOfBirth;
      selectedBloodGroup = widget.editDonorInfo!.bloodGroup;
      selectedRhFactor = widget.editDonorInfo!.rhFactor;
      phoneNumberController.text = widget.editDonorInfo!.phoneNumber;
      emailController.text = widget.editDonorInfo!.email;
      cityNameController.text = widget.editDonorInfo!.cityName;
      districtNameController.text = widget.editDonorInfo!.districtName;
      postCodeController.text = widget.editDonorInfo!.postCode;
      divisionController.text = widget.editDonorInfo!.divisionName;
      lastDateOfBloodDonationController.text =
          widget.editDonorInfo!.lastDateOfBloodDonated;
      abilityToDonateBloodController.text = GlobalVar.bloodDonorStatus(
              widget.editDonorInfo!.lastDateOfBloodDonated)
          ? AppConstant.ableToDonateBloodPlainText
          : AppConstant.notAbleToDonateBloodPlainText;
      nextDateToAbleToDonateBloodController.text =
          widget.editDonorInfo!.nextDateOfBloodDonated;
      imageUrl = widget.editDonorInfo!.photoUrl;
    }
    print('Blood Group is:$selectedBloodGroup$selectedRhFactor');
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    dateOfBirthController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    cityNameController.dispose();
    districtNameController.dispose();
    postCodeController.dispose();
    divisionController.dispose();
    lastDateOfBloodDonationController.dispose();
    abilityToDonateBloodController.dispose();
    nextDateToAbleToDonateBloodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasicAquaHazeBGUi(
        appBarTitle: AppConstant.addBloodDonorPlainText,
        child: SingleChildScrollView(child: initBuildUi()));
  }

  Widget initBuildUi() {
    return Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
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
                  // isMandatory: true,
                    hint: AppConstant.namePlainText,
                    controller: nameController,
                    keyboardInputType: TextInputType.text),
                SizedBox(
                  height: 10,
                ),
                CustomTextFormField(
                  // isMandatory: true,
                  hint: AppConstant.dateOfBirthPlainText,
                  controller: dateOfBirthController,
                  keyboardInputType: TextInputType.none,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return CustomCalendar(
                          range: AppConstant.dateTodayPlainText,
                          today: today,
                          dateChangeFunction: (selectedDate) {
                            setState(() {
                              today = selectedDate == null
                                  ? ''
                                  : selectedDate.toString().split(' ').first;
                            });
                          },
                          saveFunction: () {
                            Navigator.of(context, rootNavigator: true).pop();
                            setState(() {
                              dateOfBirthController.text = today;
                            });
                          },
                        );
                      },
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                GridView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      childAspectRatio: 5,
                      mainAxisSpacing: 10),
                  children: [
                    CustomDropdownButton(
                      hintText: widget.editDonorInfo==null?AppConstant.bloodGroupPlainText:widget.editDonorInfo!.bloodGroup,
                      dropdownList: bloodGroupList,
                      onChangedAction: (String? newValue) {
                        // Handle dropdown value change
                        setState(() {
                          selectedBloodGroup = newValue!;
                        });
                      },
                    ),
                    CustomDropdownButton(
                      hintText: widget.editDonorInfo==null?AppConstant.rhFactorPlainText:widget.editDonorInfo!.rhFactor,
                      dropdownList: rhFactorList,
                      onChangedAction: (String? newValue) {
                        // Handle dropdown value change
                        setState(() {
                          selectedRhFactor = newValue!;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextFormField(
                  // isMandatory: true,
                    hint: AppConstant.phoneNumberPlainText,
                    controller: phoneNumberController,
                    keyboardInputType: TextInputType.phone),
                SizedBox(
                  height: 10,
                ),
                CustomTextFormField(
                  // isMandatory: false,
                    hint: AppConstant.emailPlainText,
                    controller: emailController,
                    keyboardInputType: TextInputType.emailAddress),
                SizedBox(
                  height: 10,
                ),
                GridView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      childAspectRatio: 5,
                      mainAxisSpacing: 10),
                  children: [
                    CustomTextFormField(
                        // isMandatory: false,
                        hint: AppConstant.cityNamePlainText,
                        controller: cityNameController,
                        keyboardInputType: TextInputType.text),
                    CustomTextFormField(
                        // isMandatory: false,
                        hint: AppConstant.districtNamePlainText,
                        controller: districtNameController,
                        keyboardInputType: TextInputType.text),
                    CustomTextFormField(
                        // isMandatory: false,
                        hint: AppConstant.postCodePlainText,
                        controller: postCodeController,
                        keyboardInputType: TextInputType.number),
                    CustomTextFormField(
                        // isMandatory: false,
                        hint: AppConstant.divisionPlainText,
                        controller: divisionController,
                        keyboardInputType: TextInputType.text),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextFormField(
                // isMandatory: true,
                hint: AppConstant.lastDateOfBloodDonationPlainText,
                controller: lastDateOfBloodDonationController,
                keyboardInputType: TextInputType.datetime,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return CustomCalendar(
                        range: AppConstant.dateTodayPlainText,
                        today: today,
                        dateChangeFunction: (selectedDate) {
                          setState(() {
                            lastDateOfBloodDonated = selectedDate!;
                          });
                        },
                        saveFunction: () {
                          print('Selected date:$lastDateOfBloodDonated');
                          Navigator.of(context, rootNavigator: true).pop();
                          setState(() {
                            lastDateOfBloodDonationController.text =
                                lastDateOfBloodDonated
                                    .toString()
                                    .split(' ')
                                    .first;
                            nextDateToAbleToDonateBloodController.text =
                                lastDateOfBloodDonated
                                    .add(Duration(days: 90))
                                    .toString()
                                    .split(' ')
                                    .first;
                            print(
                                'Total Dys:${DateTime.now().difference(lastDateOfBloodDonated)}');
                            if (DateTime.now()
                                    .difference(lastDateOfBloodDonated)
                                    .inDays >=
                                90) {
                              abilityToDonateBloodController.text =
                                  AppConstant.ableToDonateBloodPlainText;
                            } else {
                              abilityToDonateBloodController.text =
                                  AppConstant.notAbleToDonateBloodPlainText;
                            }
                          });
                        },
                      );
                    },
                  );
                }),
            SizedBox(
              height: 10,
            ),
            CustomTextFormField(
                // isMandatory: true,
                hint: AppConstant.abilityToDonateBloodPlainText,
                controller: abilityToDonateBloodController,
                keyboardInputType: TextInputType.datetime),
            SizedBox(
              height: 10,
            ),
            CustomTextFormField(
                // isMandatory: true,
                hint: AppConstant.nextDateToAbleToDonateBloodPlainText,
                controller: nextDateToAbleToDonateBloodController,
                keyboardInputType: TextInputType.datetime),
            SizedBox(
              height: 10,
            ),
            CustomButton(
                content: widget.editDonorInfo == null
                    ? AppConstant.addPlainText
                    : AppConstant.changePlainText,
                contentColor: AppColor.white,
                backgroundColor: AppColor.killarney,
                onPressed: () async {
                  if (selectedBloodGroup.isEmpty || selectedRhFactor.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: AppColor.red,
                        content: Text(
                          'Please add Blood Group and Rh Factor',
                          style: TextStyle(color: AppColor.white),
                        )));
                  }
                  // if (formKey.currentState!.validate()) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        });
                    if (widget.editDonorInfo == null) {
                      String downloadUrl = '';
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
                                "${GlobalVar.basePath}/${AppConstant.bloodDonorGroupPath}/$uniqueName/${AppConstant.userImageName}")
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
                      await Future.delayed(
                              Duration(seconds: _imagePath.isNotEmpty ? 7 : 0))
                          .whenComplete(() async {
                        print(
                            'Upload Current time:${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}');
                        FirebaseDatabase database = FirebaseDatabase.instance;
                        final firebaseApp = Firebase.app();
                        // final rtdb = FirebaseDatabase.instanceFor(
                        //     app: firebaseApp,
                        //     databaseURL:
                        //     'https://smfmobileapp-5b74e-default-rtdb.firebaseio.com/');

                        DatabaseReference ref = database.ref(
                            "${GlobalVar.basePath}/${AppConstant.bloodDonorGroupPath}/${uniqueName}");

                        await ref.set({
                          AppConstant.nameColumnText: nameController.text,
                          AppConstant.dateOfBirthColumnText:
                              dateOfBirthController.text,
                          AppConstant.bloodGroupColumnText: selectedBloodGroup,
                          AppConstant.rhFactorColumnText: selectedRhFactor,
                          AppConstant.mobileColumnText:
                              phoneNumberController.text,
                          AppConstant.emailColumnText: emailController.text,
                          AppConstant.cityNameColumnText:
                              cityNameController.text,
                          AppConstant.districtNameColumnText:
                              districtNameController.text,
                          AppConstant.postCodeColumnText:
                              postCodeController.text,
                          AppConstant.divisionColumnText:
                              divisionController.text,
                          AppConstant.lastDateOfBloodDonationColumnText:
                              lastDateOfBloodDonationController.text,
                          AppConstant.profileImageColumnText: downloadUrl,
                        });
                      });
                    }
                    else {
                      DatabaseReference ref = FirebaseDatabase.instance.ref(
                          "${GlobalVar.basePath}/${AppConstant.bloodDonorGroupPath}/${widget.editDonorInfo!.key}");
                      ref.update({
                        AppConstant.nameColumnText: nameController.text,
                        AppConstant.dateOfBirthColumnText:
                            dateOfBirthController.text,
                        AppConstant.bloodGroupColumnText: selectedBloodGroup,
                        AppConstant.rhFactorColumnText: selectedRhFactor,
                        AppConstant.mobileColumnText:
                            phoneNumberController.text,
                        AppConstant.emailColumnText: emailController.text,
                        AppConstant.cityNameColumnText: cityNameController.text,
                        AppConstant.districtNameColumnText:
                            districtNameController.text,
                        AppConstant.postCodeColumnText: postCodeController.text,
                        AppConstant.divisionColumnText: divisionController.text,
                        AppConstant.lastDateOfBloodDonationColumnText:
                            lastDateOfBloodDonationController.text,
                      });
                    }
                    Navigator.of(context, rootNavigator: true).pop();
                    Navigator.pop(context, true);
                    print('');
                  // }
                })
          ],
        ));
  }
}
