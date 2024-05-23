import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smf/models/transaction_model.dart';
import 'package:smf/utils/values/app_constant.dart';

import '../../../../../utils/color/app_color.dart';
import '../../../../../utils/extension/theme.dart';
import '../../../../../utils/functionalities/functions.dart';
import 'business_transaction_details.dart';

class AddNewBusinessTransactionEntryScreen extends StatefulWidget {
  AddNewBusinessTransactionEntryScreen(
      {super.key,
      required this.path,
      required this.selectedTransaction});
  String path;
  TransactionModel selectedTransaction;

  @override
  State<AddNewBusinessTransactionEntryScreen> createState() =>
      _AddNewBusinessTransactionEntryScreenState();
}

class _AddNewBusinessTransactionEntryScreenState
    extends State<AddNewBusinessTransactionEntryScreen> {
  String _imagePath = '';
  bool isDebit = true;

  String today =
      '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();
  TextEditingController entryTitleController = TextEditingController();
  TextEditingController entryDetailsController = TextEditingController();
  TextEditingController entryAmountController = TextEditingController();

  @override
  void initState() {
    print('Path:${widget.path}');
    super.initState();
  }

  @override
  void dispose() {
    dateController.dispose();
    entryTitleController.dispose();
    entryDetailsController.dispose();
    entryAmountController.dispose();
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
      child: SingleChildScrollView(child: initBuildUi()),
    );
  }

  Widget initBuildUi() {
    return Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextFormField(
                      // isMandatory: true,
                      hint: AppConstant.datePlainText,
                      controller: dateController,
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
                                      : selectedDate
                                          .toString()
                                          .split(' ')
                                          .first;
                                });
                              },
                              saveFunction: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                setState(() {
                                  dateController.text = today;
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
                      hint: AppConstant.entryTitlePlainText,
                      controller: entryTitleController,
                      keyboardInputType: TextInputType.text),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                      // isMandatory: true,
                      hint: AppConstant.entryDetailsPlainText,
                      controller: entryDetailsController,
                      keyboardInputType: TextInputType.text),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                      // isMandatory: true,
                      hint: AppConstant.moneyAmountPlainText,
                      controller: entryAmountController,
                      keyboardInputType: TextInputType.numberWithOptions()),
                  SizedBox(
                    height: 10,
                  ),
                  initEntryTypeUI(),
                  SizedBox(
                    height: 10,
                  ),
                  _imagePath.isEmpty
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
              SizedBox(
                height: 120,
              ),
              CustomButton(
                  content: AppConstant.saveEntryPlainText,
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
                      String uniqueName = GlobalVar.customNameEncoder(
                          entryTitleController.text);
                      final storageRef = FirebaseStorage.instance.ref();
                      /*if(_imagePath.isNotEmpty){
                          File file = File(_imagePath);
                          final metadata = SettableMetadata(contentType: "image/jpeg");
                          print('Image Path: $_imagePath');
                          print('File Path: ${file.path}');
                          final uploadTask = storageRef.child("${widget.path}/$uniqueName/${AppConstant.userImageName}").putFile(file,metadata);
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
                        }*/
                      // await Future.delayed(const Duration(seconds: _imagePath.isNotEmpty ? 7 : 0)).whenComplete(() async{
                      print(
                          'Upload Current time:${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}');
                      FirebaseDatabase database = FirebaseDatabase.instance;

                      DatabaseReference ref = database.ref(
                          "${widget.path}/${AppConstant.entryColumnText}/$uniqueName");
                      print(
                          'UPload path:${widget.path}/${AppConstant.entryColumnText}/$uniqueName');

                      await ref.set({
                        AppConstant.entryDateColumnText: dateController.text,
                        AppConstant.entryTitleColumnText:
                            entryTitleController.text,
                        AppConstant.entryDetailsColumnText:
                            entryDetailsController.text,
                        AppConstant.entryAmountColumnText:
                            entryAmountController.text,
                        AppConstant.debitOrCreditColumnText: isDebit,
                      });

                      double updateTotalIncome =
                          double.parse(widget.selectedTransaction.income);
                      double updateTotalExpense =
                          double.parse(widget.selectedTransaction.expense);
                      double updateRemainingBalance = 0;

                      if (isDebit) {
                        updateTotalExpense +=
                            double.parse(entryAmountController.text);
                        updateRemainingBalance =
                            updateTotalIncome - updateTotalExpense;
                      } else {
                        updateTotalIncome +=
                            double.parse(entryAmountController.text);
                        updateRemainingBalance =
                            updateTotalIncome - updateTotalExpense;
                      }
                      ref = database.ref(widget.path);
                      print('Updated income:$updateTotalIncome, expense: $updateTotalExpense, balance: $updateRemainingBalance');
                      await ref.update({
                        AppConstant.expenseColumnText:
                            updateTotalExpense.toString(),
                        AppConstant.incomeColumnText:
                            updateTotalIncome.toString(),
                        AppConstant.remainingBalanceColumnText:
                            updateRemainingBalance.toString(),
                      });
                      Navigator.of(context, rootNavigator: true).pop();
                      Navigator.pop(context,true);
                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BusinessTransactionDetailsScreen(
                      //   path: widget.path,imageUrl: widget.imageUrl,selectedTransaction: widget.selectedTransaction,
                      // )));

                    }
                  })
            ],
          ),
        ));
  }

  Widget initEntryTypeUI() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: AppColor.grey),
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(AppConstant.entryTypePlainText),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                  onPressed: () {
                    isDebit = true;
                  },
                  child: Text(
                    '- ${AppConstant.debitPlainText}',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColor.red),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(AppColor.nebula),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))))),
              ElevatedButton(
                  onPressed: () {
                    isDebit = false;
                  },
                  child: Text(
                    '+ ${AppConstant.creditPlainText}',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColor.white),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(AppColor.killarney),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))))),
              // CustomButton(content: AppConstant.creditPlainText, contentColor: AppColor.red, backgroundColor: AppColor.nebula, onPressed: (){}),
            ],
          )
        ],
      ),
    );
  }
}
