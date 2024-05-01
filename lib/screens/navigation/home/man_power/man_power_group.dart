import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../../../utils/color/app_color.dart';
import '../../../../utils/extension/theme.dart';
import '../../../../utils/values/app_constant.dart';
import 'man_power_list_screen.dart';

class ManPowerGroupScreen extends StatefulWidget {
  const ManPowerGroupScreen({super.key});

  @override
  State<ManPowerGroupScreen> createState() => _ManPowerGroupScreenState();
}

class _ManPowerGroupScreenState extends State<ManPowerGroupScreen> {
  TextEditingController groupNameController = TextEditingController();
  List<String> groups = [];
  Map<String,String> groupMap = {};

  Future<List<String>>? _groupsFuture;

  Future<List<String>> getGroupList() async {
    print('Initiated');
    FirebaseDatabase database = FirebaseDatabase.instance;
    final firebaseApp = Firebase.app();
    final rtdb = FirebaseDatabase.instanceFor(
        app: firebaseApp,
        databaseURL: 'https://smfmobileapp-5b74e-default-rtdb.firebaseio.com/');

    //database.ref("${AppConstant.manPowerGroupPath}/${groupNameController.text}/people0");
    DatabaseReference ref = database.ref("${AppConstant.manPowerGroupPath}/");
    //print(ref.);
    groups.clear();
    await ref.once().then((event) {
      if (event.snapshot.exists) {
        // Extract the data as a Map
        Map<dynamic, dynamic> groupData =
            event.snapshot.value as Map<dynamic, dynamic>;
        for (var key in groupData.keys) {
          //print('After getting a key, the value is ${groupData[key]}');
          setState(() {
            String groupNameForShow = key.toString().split('?').first;
            groupNameForShow = groupNameForShow.replaceAll('_', ' ');
            groupMap[groupNameForShow]=key.toString();
            groups.add(groupNameForShow);
            //groups.add(key);
          });
        }
        print('Group Map:$groupMap');
      } else {
        print("Group with ID '123' does not exist.");
      }
    });
    return groups;
  }

  @override
  void initState() {
    super.initState();
    _groupsFuture = getGroupList();
  }

  @override
  void dispose() {
    groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasicAquaHazeBGUi(
      appBarTitle: AppConstant.manPowerListPlainText,
      child: initBuildUi(),
    );
  }

  Widget initBuildUi() {
    return Column(
      children: [
        initSearchAndAddAccountUi(),
        const SizedBox(
          height: 10,
        ),
        initManPowerGroupUi()
      ],
    );
  }

  Widget initSearchAndAddAccountUi() {
    return TextFormField(
      decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          suffixIcon: Icon(
            Icons.search,
            color: AppColor.alto,
          ),
          hintText: AppConstant.searchPlainText,
          hintStyle: TextStyle(color: AppColor.alto),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.aquaHaze))),
    );
  }

  Widget initManPowerGroupUi() {
    return TitleIconButtonWithWhiteBackground(
        headline: AppConstant.manpowerGroupListPlainText,
        actionIcon: Icons.add,
        action: () {
          // Navigator.push(context, MaterialPageRoute(builder: (context)=>AddManpowerScreen()));
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                    '${AppConstant.manpowerGroupListPlainText} ${AppConstant.addPlainText}'),
                content: TextFormField(
                  controller: groupNameController,
                ),
                actions: [
                  TextButton(
                      onPressed: () async {
                        showDialog(context: context, builder: (context){
                          return Center(child: CircularProgressIndicator(),);
                        });
                        String groupName = "${groupNameController.text.replaceAll(' ', '_')}?${DateTime.now().toString().replaceAll(' ', '@').replaceAll('.', ':')}";
                        print('Group Name is: $groupName');
                        FirebaseDatabase database = FirebaseDatabase.instance;
                        final firebaseApp = Firebase.app();
                        final rtdb = FirebaseDatabase.instanceFor(
                            app: firebaseApp,
                            databaseURL:
                                'https://smfmobileapp-5b74e-default-rtdb.firebaseio.com/');

                        DatabaseReference ref = database.ref(
                            "${AppConstant.manPowerGroupPath}/$groupName/people0");

                        await ref.set({
                          "name": "",
                          "age": 0,
                        });
                        _groupsFuture = getGroupList();
                        Navigator.of(context,rootNavigator: true).pop();
                        Navigator.of(context,rootNavigator: true).pop();
                        groupNameController.clear();
                        print('');
                      },
                      child: Text(AppConstant.addPlainText))
                ],
              );
            },
          );
        },
        whatToShow: FutureBuilder<List<String>>(
          future: _groupsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            else {
              //groups = snapshot.data!;
              print('Snapshot values:${snapshot.data!}');
              return GridView.builder(
                itemCount: groups.length,
                physics: AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1),
                itemBuilder: (context, index) {
                  return CardAquaHazeWithColumnIconAndTitle(
                    title: groups[index],
                    action: () {
                      print('You pressed ${groups[index]} which means ${groupMap[groups[index]]}');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ManPowerGroupListScreen(selectedGroup: groupMap[groups[index]]!
                              )));
                    },
                  );
                },
              );
            }
          },
        ));
  }
}
