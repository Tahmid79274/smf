import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smf/utils/functionalities/functions.dart';

import '../values/app_constant.dart';
class CustomFirebaseFunctionality{
  static void deleteEntry(String entryPath){

  }

  static void logout()async{
    await FirebaseAuth.instance.signOut();
  }

  static Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  static Future<String> uploadImage(String fileName,String imagePath)async{
      final storageRef = FirebaseStorage.instance.ref();
      File file = File(imagePath);
      final metadata = SettableMetadata(contentType: "image/jpeg");
      String downloadUrl = '';

      final uploadTask = storageRef
          .child(
          //"${GlobalVar.basePath}/${AppConstant.bloodDonorGroupPath}/$uniqueName/${AppConstant.userImageName}")
          "$fileName/${AppConstant.userImageName}")
          .putFile(file, metadata);
      uploadTask.snapshotEvents
          .listen((TaskSnapshot taskSnapshot) async  {
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

      return downloadUrl;
    }

  static Future<bool> addEntry(String downloadUrl,String path,Map<String,String> body)async{

    FirebaseDatabase database = FirebaseDatabase.instance;
    // final firebaseApp = Firebase.app();
    // final rtdb = FirebaseDatabase.instanceFor(
    //     app: firebaseApp,
    //     databaseURL:
    //     'https://smfmobileapp-5b74e-default-rtdb.firebaseio.com/');

    DatabaseReference ref = database.ref(path); // "${GlobalVar.basePath}/${AppConstant.bloodDonorGroupPath}/${uniqueName}");
    await ref.set(body);

    // await ref.set({
    //   AppConstant.nameColumnText: nameController.text,
    //   AppConstant.dateOfBirthColumnText:
    //   dateOfBirthController.text,
    //   AppConstant.bloodGroupColumnText: selectedBloodGroup,
    //   AppConstant.rhFactorColumnText: selectedRhFactor,
    //   AppConstant.mobileColumnText:
    //   phoneNumberController.text,
    //   AppConstant.addressColumnText: addressController.text,
    //   AppConstant.lastDateOfBloodDonationColumnText:
    //   lastDateOfBloodDonationController.text,
    //   AppConstant.profileImageColumnText: downloadUrl,
    // });
    return true;
  }
}