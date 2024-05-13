import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smf/screens/auth/welcome_screen.dart';
import 'package:smf/utils/extension/theme.dart';
import 'package:smf/utils/functionalities/functions.dart';
import 'package:smf/utils/functionalities/shared_prefs_manager.dart';

import '../../../models/user_profile_model.dart';
import '../../../utils/color/app_color.dart';

class ProfileManageScreen extends StatefulWidget {
  const ProfileManageScreen({super.key});

  @override
  State<ProfileManageScreen> createState() => _ProfileManageScreenState();
}

class _ProfileManageScreenState extends State<ProfileManageScreen> {

  TextEditingController newPassword = TextEditingController();


  late Future<UserProfileModel> getProfileInfo;
  Future<UserProfileModel> getProfileInformation()async{
    return UserProfileModel(
        displayName: await SharedPrefsManager.getUserName(),
        email: await SharedPrefsManager.getUID(),
        uid: await SharedPrefsManager.getUID(),
        photoUrl: await SharedPrefsManager.getProfilePhotoLink());
  }

  @override
  void initState(){
    getProfileInfo = getProfileInformation();
    super.initState();
  }
  @override
  void dispose(){
    newPassword.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.timberGreen,
        iconTheme: IconThemeData(color: AppColor.white),
        elevation: 0,
        title: Text(
          'Manage Profile',
          style: TextStyle(color: AppColor.white),
        ),
      ),
      body: FutureBuilder<UserProfileModel>(
        future: getProfileInfo,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          else if(snapshot.hasError){
            return Center(child: Text('Reconnect with your internet'),);
          }
          else{
            return ListView(
              padding: EdgeInsets.all(10),
              children: [
                SizedBox(
                  width: 30,
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 10,
                    top: 10,
                    bottom: 10,
                  ),
                  width: 50,
                  height: 50,
                  decoration: snapshot.data!.photoUrl.isNotEmpty
                      ? BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(
                            snapshot.data!.photoUrl,
                          ),
                          fit: BoxFit.fill))
                      : BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.sepiaBlack,
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Text('Username: ${snapshot.data!.displayName}',style: TextStyle(fontSize: 30),),
                SizedBox(
                  width: 30,
                ),
                CustomButton(content: 'Change Password', contentColor: AppColor.white,
                    backgroundColor: AppColor.green, onPressed: (){
                      showDialog(context: context, builder: (context) {
                        return AlertDialog(title: Text('Enter your New Password'),
                          content: CustomTextFormField(
                            controller: newPassword,
                            keyboardInputType: TextInputType.text,
                            hint: 'Password',
                          ),
                          actions: [
                            TextButton(onPressed: ()async{
                              showDialog(context: context, builder: (context)=>Center(child: CircularProgressIndicator(),));
                              final user = FirebaseAuth.instance.currentUser;
                              if (user != null) {
                                // Get the new password from a text field or other input source
                                final newPassword = 'your_new_password'; // Replace with actual new password

                                try {
                                  await user.updatePassword(newPassword);
                                  print('Password updated successfully!');
                                  // Optionally, navigate to a success screen or display a confirmation message
                                } on FirebaseAuthException catch (e) {
                                  // Handle errors related to password update
                                  if (e.code == 'weak-password') {
                                    print('The password is too weak.');
                                  } else if (e.code == 'requires-recent-login') {
                                    print('This operation requires recent login. Please sign in again before changing your password.');
                                  } else {
                                    print("Error updating password: ${e.code}");
                                  }
                                } catch (e) {
                                  // Handle other unexpected errors
                                  print("An unexpected error occurred: ${e}");
                                }
                              } else {
                                print('No user signed in. Please sign in first.');
                                // Optionally, navigate to a sign-in screen
                              }
                              Navigator.of(context,rootNavigator: true).pop();
                            }, child: Text('Update'))
                          ],
                        );
                      },);

                    }),
                SizedBox(
                  width: 30,
                ),
                CustomButton(content: 'Logout', contentColor: AppColor.white,
                    backgroundColor: AppColor.green, onPressed: ()async{
                      SharedPrefsManager.setSplash(false);
                      SharedPrefsManager.setProfilePhotoLink('');
                      SharedPrefsManager.setUID('');
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>WelcomeScreen()), (route) => true);
                    }),
              ],
            );
          }
        },
      ),
    );
  }
}
